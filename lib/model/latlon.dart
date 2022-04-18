import 'package:json_annotation/json_annotation.dart';

part 'latlon.g.dart';

@JsonSerializable()
class LatLon {
  double lat;
  double lon;

  LatLon(this.lat, this.lon);

  factory LatLon.fromJson(Map<String, dynamic> json) => _$LatLonFromJson(json);

  Map<String, dynamic> toJson() => _$LatLonToJson(this);

  @override
  String toString() => '($lat, $lon)';
}