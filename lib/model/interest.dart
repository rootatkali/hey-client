import 'package:json_annotation/json_annotation.dart';

part 'interest.g.dart';

@JsonSerializable()
class Interest {
  String id;
  String name;

  Interest(this.id, this.name);

  factory Interest.fromJson(Map<String, dynamic> json) => _$InterestFromJson(json);

  Map<String, dynamic> toJson() => _$InterestToJson(this);

  @override
  String toString() => '$name [$id]';
}