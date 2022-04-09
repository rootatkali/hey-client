import 'package:json_annotation/json_annotation.dart';

part 'school.g.dart';

@JsonSerializable()
class School {
  int id;
  String name;
  String? town;

  School(this.id, this.name, this.town);

  factory School.fromJson(Map<String, dynamic> json) => _$SchoolFromJson(json);

  Map<String, dynamic> toJson() => _$SchoolToJson(this);

  @override
  String toString() => '[$id] $name';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is School &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}