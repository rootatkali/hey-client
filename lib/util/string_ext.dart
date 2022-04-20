extension NullableString on String? {
  /// returns [true] if the String? is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

extension StringExt on String {
  /// Returns [true] if this contains [other] or any other capitalization of it.
  ///
  /// See [String.contains] for more information.
  bool containsIgnoreCase(String other, [int startIndex = 0]) =>
      toLowerCase().contains(other.toLowerCase(), startIndex);
}
