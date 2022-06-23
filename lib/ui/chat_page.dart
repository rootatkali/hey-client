import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:hey/api/chat_service.dart';
import 'package:hey/api/encryption.dart';
import 'package:hey/model/chat_message.dart';
import 'package:hey/model/chat_notification.dart';
import 'package:hey/model/friend_view.dart';
import 'package:hey/model/user.dart';
import 'package:hey/util/constants.dart';

class ChatPage extends StatefulWidget {
  static const path = "/chat";

  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late List<MessageWithBody> messages;
  late User user;
  late FriendView friend;
  late ChatModule chat;
  late CryptoKey key;
  bool _loading = true;

  // Chat module types
  final List<types.Message> chatMessages = [];
  late types.User chatUser;
  late types.User chatFriend;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    // load user
    user = await Constants.api.getMe();
    chatUser = types.User(
      id: user.id!,
      firstName: user.firstName!,
      lastName: user.lastName!,
    );

    // load friend
    friend = ModalRoute.of(context)!.settings.arguments as FriendView;
    chatFriend = types.User(
      id: friend.id,
      firstName: friend.firstName,
      lastName: friend.lastName,
    );

    final map = <String, types.User>{
      user.id!: chatUser,
      friend.id: chatFriend,
    };

    // load chat module
    chat = Constants.chatService.registerChat(user);

    // load key
    key = await chat.generateCryptoKey(friend);

    // load message history
    messages = await chat.fetchChatHistory(friend, key);

    for (final m in messages) {
      final txt = types.TextMessage(
        author: map[m.message.sender]!,
        id: m.message.id!,
        text: m.body,
      );
      chatMessages.insert(0, txt);
    }

    // turn off loading
    _loading = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final friend = ModalRoute.of(context)!.settings.arguments as FriendView;

    // subscribe to message queue
    if (!_loading) chat.createQueueStream(friend).listen(_receiveMessage);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${friend.name}'),
      ),
      body: _loading
          ? const CircularProgressIndicator()
          : Chat(
              messages: chatMessages,
              onSendPressed: _sendMessage,
              user: chatUser,
            ),
    );
  }

  void _sendMessage(types.PartialText msg) async {
    final callback = await chat.sendMessage(friend, msg.text, key);

    final textMsg = types.TextMessage(
      author: chatUser,
      id: callback.message.id!,
      text: msg.text,
    );

    setState(() => chatMessages.insert(0, textMsg));
  }

  void _receiveMessage(ChatNotification notification) async {
    if (notification.id == chatMessages[0]?.id) return;

    final message = await chat.fetchMessage(notification.id, key);

    final textMsg = types.TextMessage(
      author: chatFriend,
      id: message.message.id!,
      text: message.body,
    );

    _addMessage(textMsg);
  }

  void _addMessage(types.Message msg) {
    chatMessages.insert(0, msg);
    final set = chatMessages.toSet();
    chatMessages.retainWhere((m) => set.remove(m));

    setState(() {});
  }

}
