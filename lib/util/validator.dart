import 'package:hey/util/string_ext.dart';

/// Validation is repeated in  serverside
/// (see [me.rootatkali.hey.service.Validator]).
class Validator {
  /// Validate usernames as per server instructions.
  /// <p>Requirements:
  /// <ul>
  /// <li> length >= 3
  /// <li> is alphanum, starts with letter
  static String? validateUsername(String? username) {
    // length >= 3
    if (username == null || username.length < 3) {
      return "Your username must contain at least 3 characters.";
    }

    // alphanum, starts with letter
    return RegExp(r'^[a-zA-Z][a-zA-Z0-9]+$', unicode: true).hasMatch(username)
        ? null
        : "Your username must be alphanumeric and start with a letter.";
  }

  /// This one isn't possible to validate in Dart, due to different character
  /// object representations.
  static String? validateName(String? name) =>
      name.isNullOrEmpty ? "Your name must not be empty." : null;

  /// Validate email by using the same regex from the server
  static String? validateEmail(String? email) {
    if (email.isNullOrEmpty) return "Your email is required.";

    return RegExp(r"^[a-zA-Z0-9_!#$%&'*+/=?`{|}~^.-]+@[a-zA-Z0-9.-]+$",
                unicode: true)
            .hasMatch(email!)
        ? null
        : "Your email is not valid.";
  }

  /// Validate mobile numbers according to the Israeli format
  static String? validatePhoneNumber(String? number) {
    // 10-digit number
    if (number == null || number.length != 10) {
      return "Your phone number must be 10 digits.";
    }
    if (int.tryParse(number) == null) {
      return "Your phone number must contain only numbers.";
    }

    const invalidNum = "Your number is not a valid mobile number.";
    // mobile carrier prefix
    if (!number.startsWith("05")) return invalidNum;
    return <String>['0', '1', '2', '3', '4', '5', '8']
            .contains(number.substring(2, 3))
        ? null
        : invalidNum;
  }

  /// Validate passwords according to the following terms:
  /// <ul>
  /// <li> 8-64 chars
  /// <li> At least 3 of the following:
  /// <ul>
  /// <li> Uppercase character
  /// <li> Lowercase character
  /// <li> Digit
  /// <li> Any of the following special characters: <code>-,. !@#$%^&*()_+=/[]{}\</code>
  static String? validatePassword(String? password) {
    // 8 <= length <= 64
    if (password == null || password.length < 8 || password.length > 64) {
      return "Your password must be between 8 and 64 characters.";
    }

    int checks = 0;

    // uppercase
    if (RegExp(r'[A-Z]', unicode: true).hasMatch(password)) checks++;
    // lowercase
    if (RegExp(r'[a-z]', unicode: true).hasMatch(password)) checks++;
    // digit
    if (RegExp(r'[0-9]', unicode: true).hasMatch(password)) checks++;
    // special
    if (RegExp(r'[-,. !@#$%^&*()_+=/\[\]{}\\]', unicode: true)
        .hasMatch(password)) checks++;

    return checks >= 3 ? null : "Your password isn't secure enough.";
  }
}
