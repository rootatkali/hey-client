// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendView _$FriendViewFromJson(Map<String, dynamic> json) => FriendView(
      id: json['id'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      status: json['status'] as String?,
      initiated: json['initiated'] as bool,
      bio: json['bio'] as String,
      school: School.fromJson(json['school'] as Map<String, dynamic>),
      interests: (json['interests'] as List<dynamic>)
          .map((e) => Interest.fromJson(e as Map<String, dynamic>))
          .toList(),
      hometown: json['hometown'] as String?,
      distance: (json['distance'] as num).toDouble(),
      grade: json['grade'] as int,
      gender: json['gender'] as String,
      matchScore: (json['matchScore'] as num).toDouble(),
    );

Map<String, dynamic> _$FriendViewToJson(FriendView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'status': instance.status,
      'initiated': instance.initiated,
      'bio': instance.bio,
      'school': instance.school,
      'interests': instance.interests,
      'hometown': instance.hometown,
      'distance': instance.distance,
      'grade': instance.grade,
      'gender': instance.gender,
      'matchScore': instance.matchScore,
    };
