import 'package:json_annotation/json_annotation.dart';

part 'chat_notification.g.dart';

@JsonSerializable()
class ChatNotification {
  String id;
  String senderId;
  String name;


  ChatNotification(this.id, this.senderId, this.name);

  factory ChatNotification.fromJson(Map<String, dynamic> json) =>
      _$ChatNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$ChatNotificationToJson(this);
}
