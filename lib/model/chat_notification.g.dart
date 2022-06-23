// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatNotification _$ChatNotificationFromJson(Map<String, dynamic> json) =>
    ChatNotification(
      json['id'] as String,
      json['senderId'] as String,
      json['name'] as String,
    );

Map<String, dynamic> _$ChatNotificationToJson(ChatNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'name': instance.name,
    };
