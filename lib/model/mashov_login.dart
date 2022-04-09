import 'package:json_annotation/json_annotation.dart';

part 'mashov_login.g.dart';

@JsonSerializable()
class MashovLogin {
  int semel;
  int year;
  String username;
  String password;

  MashovLogin(this.semel, this.year, this.username, this.password);

  factory MashovLogin.fromJson(Map<String, dynamic> json) =>
      _$MashovLoginFromJson(json);

  Map<String, dynamic> toJson() => _$MashovLoginToJson(this);
}
