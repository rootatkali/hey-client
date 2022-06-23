import 'dart:async';
import 'dart:convert';

import 'package:hey/api/cookie_interceptor.dart';
import 'package:hey/api/encryption.dart';
import 'package:hey/api/endpoints.dart';
import 'package:hey/model/chat_message.dart';
import 'package:hey/model/chat_notification.dart';
import 'package:hey/model/friend_view.dart';
import 'package:hey/model/user.dart';
import 'package:hey/util/constants.dart';
import 'package:hey/util/json_converter.dart';
import 'package:hey/util/log.dart';
import 'package:hey/util/string_ext.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';

class ChatService with Log {
  const ChatService();

  ChatModule registerChat(User user) {
    StompClient client = StompClient(
      config: StompConfig.SockJS(
        url: Endpoints.socketUri,
        onConnect: (frame) {
          log.i('WebSocket for user ${user.id} connected');
          // TODO onConnect?
        },
        onStompError: (error) {
          log.e('STOMP Error $error');
        },
        onWebSocketError: (error) {
          log.e('WebSocket Error $error');
        },
        onDisconnect: (frame) {
          log.i('WebSocket for user ${user.id} disconnected');
          // TODO onDisconnect?
        },
      ),
    );

    client.activate();

    return ChatModule(user, client);
  }
}

class ChatModule with Log {
  final User user;
  final StompClient _client;
  static const ListToUint8ListConverter _converter = ListToUint8ListConverter();

  ChatModule(this.user, this._client);

  /// Generates a [Stream] for the [ChatNotification] queue, to be subscribed to
  /// by UI elements and notification services.
  Stream<ChatNotification> createQueueStream(FriendView friend) {
    // New stream because client does not support returning streams
    final controller = StreamController<ChatNotification>.broadcast();


    _client.subscribe(
      destination: Endpoints.messageQueue(user, friend),
      callback: (frame) {
        // Fetch message
        final raw = frame.body;
        if (raw.isNullOrEmpty) return;

        // Decode message to Map<String, dynamic>
        final json = jsonDecode(raw!);
        if (json is List) {
          log.wtf('Socket error: User ${user.id}, Callback: $raw');
          return;
        }

        // Build notification object and add to stream
        final notification = ChatNotification.fromJson(json);
        log.i('new ${notification.id}');
        controller.add(notification);
      },
    );

    return controller.stream; // Stream object
  }

  Future<MessageWithBody> fetchMessage(
      String id, CryptoKey key) async {
    final raw = await Constants.api.getMessage(id);
    log.i(raw.body);

    final bytes = raw.body;
    final body = await key.decrypt(bytes);

    return MessageWithBody(raw, body);
  }

  Future<MessageWithBody> sendMessage(
      FriendView friend, String content, CryptoKey key) async {
    final encrypted = await key.encrypt(content);

    final message = Message(
      body: encrypted,
      sender: user.id!,
      recipient: friend.id,
      type: MessageType.text,
    );

    final auth = await CookieInterceptor().fetchAuth();

    final payload = ChatPayload(auth, message);

    _client.send(
      destination: Endpoints.sendMessage,
      body: jsonEncode(payload),
    );

    return (await fetchChatHistory(friend, key)).last;
  }

  Future<CryptoKey> generateCryptoKey(FriendView friend) async {
    // Fetch key
    final publicKey = await Constants.api.retrieveKey(friend.id);
    // Generate cryptoKey
    final key = await CryptoKey.generate(publicKey);
    return key;
  }

  Future<List<MessageWithBody>> fetchChatHistory(FriendView friend, CryptoKey key) async {
    final messages = await Constants.api.getChatHistory(friend.id);
    final ret = <MessageWithBody>[];

    for (final m in messages) {
      ret.add(await fetchMessage(m.id!, key));
    }

    return ret;
  }
}
