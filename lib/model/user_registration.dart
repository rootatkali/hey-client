import 'package:json_annotation/json_annotation.dart';

part 'user_registration.g.dart';

@JsonSerializable()
class UserRegistration {
  String? username;
  String? password;
  String? email;
  String? firstName;
  String? lastName;
  String? phoneNum;
  DateTime? birthdate;

  UserRegistration(
      {this.username,
      this.password,
      this.email,
      this.firstName,
      this.lastName,
      this.phoneNum,
      this.birthdate});

  factory UserRegistration.fromJson(Map<String, dynamic> json) =>
      _$UserRegistrationFromJson(json);

  Map<String, dynamic> toJson() => _$UserRegistrationToJson(this);
}
