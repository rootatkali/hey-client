import 'dart:convert';
import 'dart:typed_data';

import 'package:hey/util/json_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

@JsonSerializable()
class Message {
  String? id;
  String? chat;
  MessageType? type;
  MessageStatus? status;
  @StringToUint8ListConverter()
  Uint8List body;
  String sender;
  String recipient;

  Message(
      {this.id,
      this.chat,
      this.type,
      this.status,
      required this.body,
      required this.sender,
      required this.recipient});

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

enum MessageType {
  @JsonValue('PUBLIC_KEY')
  publicKey,
  @JsonValue('TEXT')
  text,
  @JsonValue('BLOB')
  blob,
  @JsonValue('RECEIPT')
  receipt
}

enum MessageStatus {
  @JsonValue('SENT')
  sent,
  @JsonValue('DELIVERED')
  delivered,
  @JsonValue('SEEN')
  seen
}

class MessageWithBody {
  final Message message;
  final String body;

  MessageWithBody(this.message, this.body);
}

@JsonSerializable()
class ChatPayload {
  final String auth;
  final Message message;

  ChatPayload(this.auth, this.message);

  factory ChatPayload.fromJson(Map<String, dynamic> json) =>
      _$ChatPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$ChatPayloadToJson(this);
}
