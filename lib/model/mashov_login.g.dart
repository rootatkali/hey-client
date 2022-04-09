// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mashov_login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MashovLogin _$MashovLoginFromJson(Map<String, dynamic> json) => MashovLogin(
      json['semel'] as int,
      json['year'] as int,
      json['username'] as String,
      json['password'] as String,
    );

Map<String, dynamic> _$MashovLoginToJson(MashovLogin instance) =>
    <String, dynamic>{
      'semel': instance.semel,
      'year': instance.year,
      'username': instance.username,
      'password': instance.password,
    };
