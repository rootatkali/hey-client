extension NullableString on String? {
  /// returns [true] if the String? is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
