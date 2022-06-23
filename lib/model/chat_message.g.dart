// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['id'] as String?,
      chat: json['chat'] as String?,
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']),
      status: $enumDecodeNullable(_$MessageStatusEnumMap, json['status']),
      body: const StringToUint8ListConverter().fromJson(json['body'] as String),
      sender: json['sender'] as String,
      recipient: json['recipient'] as String,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'chat': instance.chat,
      'type': _$MessageTypeEnumMap[instance.type],
      'status': _$MessageStatusEnumMap[instance.status],
      'body': const StringToUint8ListConverter().toJson(instance.body),
      'sender': instance.sender,
      'recipient': instance.recipient,
    };

const _$MessageTypeEnumMap = {
  MessageType.publicKey: 'PUBLIC_KEY',
  MessageType.text: 'TEXT',
  MessageType.blob: 'BLOB',
  MessageType.receipt: 'RECEIPT',
};

const _$MessageStatusEnumMap = {
  MessageStatus.sent: 'SENT',
  MessageStatus.delivered: 'DELIVERED',
  MessageStatus.seen: 'SEEN',
};

ChatPayload _$ChatPayloadFromJson(Map<String, dynamic> json) => ChatPayload(
      json['auth'] as String,
      Message.fromJson(json['message'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatPayloadToJson(ChatPayload instance) =>
    <String, dynamic>{
      'auth': instance.auth,
      'message': instance.message,
    };
