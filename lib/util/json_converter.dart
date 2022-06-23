import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

class ListToUint8ListConverter implements JsonConverter<Uint8List, List<int>> {
  const ListToUint8ListConverter();

  @override
  Uint8List fromJson(List<int> json) {
    return Uint8List.fromList(json);
  }

  @override
  List<int> toJson(Uint8List list) {
    return list.toList();
  }

}

class StringToUint8ListConverter implements JsonConverter<Uint8List, String> {
  const StringToUint8ListConverter();

  @override
  Uint8List fromJson(String json) {
    return base64Decode(json);
  }

  @override
  String toJson(Uint8List object) {
    return base64Encode(object);
  }
  
  
}