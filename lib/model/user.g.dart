// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String?,
      username: json['username'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phoneNum: json['phoneNum'] as String?,
      email: json['email'] as String?,
      hometown: json['hometown'] as String?,
      birthdate: json['birthdate'] == null
          ? null
          : DateTime.parse(json['birthdate'] as String),
      grade: json['grade'] as int?,
      gender: json['gender'] as String?,
      bio: json['bio'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNum': instance.phoneNum,
      'email': instance.email,
      'hometown': instance.hometown,
      'birthdate': instance.birthdate?.toIso8601String(),
      'grade': instance.grade,
      'gender': instance.gender,
      'bio': instance.bio,
    };
