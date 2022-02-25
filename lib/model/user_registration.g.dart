// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegistration _$UserRegistrationFromJson(Map<String, dynamic> json) =>
    UserRegistration(
      username: json['username'] as String?,
      password: json['password'] as String?,
      email: json['email'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phoneNum: json['phoneNum'] as String?,
      birthdate: json['birthdate'] == null
          ? null
          : DateTime.parse(json['birthdate'] as String),
    );

Map<String, dynamic> _$UserRegistrationToJson(UserRegistration instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNum': instance.phoneNum,
      'birthdate': instance.birthdate?.toIso8601String(),
    };
