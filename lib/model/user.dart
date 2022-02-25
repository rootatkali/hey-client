import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String? id;
  String? username;
  String? firstName;
  String? lastName;
  String? phoneNum;
  String? email;
  String? hometown;
  DateTime? birthdate;
  int? grade;
  String? gender;
  String? bio;

  User(
      {this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.phoneNum,
      this.email,
      this.hometown,
      this.birthdate,
      this.grade,
      this.gender,
      this.bio});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
