import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CookieInterceptor extends Interceptor {
  SharedPreferences? _prefs;
  static const key = 'cookies';
  final Logger logger = Logger();

  @override
  void onRequest(options, handler) async {
    // load cookies to request

    _prefs ??= await SharedPreferences.getInstance();

    // load cookies from shared prefs
    final cookies = _prefs!.getStringList(key) ?? <String>[];
    final header = cookies
        .map((s) => SerializableCookie.fromJson(s).cookie)
        .where((c) =>
            c.domain == options.uri.host &&
            (c.expires?.isAfter(DateTime.now()) ?? true))
        .map((c) => Cookie(c.name, c.value)..httpOnly = false)
        .map((c) => c.toString())
        .join("; ");

    options.headers[HttpHeaders.cookieHeader] = header;

    handler.next(options);
  }

  @override
  void onResponse(response, handler) async {
    // save cookies to response

    _prefs ??= await SharedPreferences.getInstance();

    // get cookies from response
    final header = response.headers[HttpHeaders.setCookieHeader] ?? <String>[];
    final cookies = header
        .map(
            (s) => Cookie.fromSetCookieValue(s)..domain = response.realUri.host)
        .map((c) => SerializableCookie(c))
        .toList();

    final saved = _prefs!
            .getStringList(key)
            ?.map((s) => SerializableCookie.fromJson(s))
            .toList(growable: true) ??
        <SerializableCookie>[]; // explicit growable

    // update cookies in list
    for (var c in cookies) {
      var index = saved.indexWhere((s) => s.cookie.name == c.cookie.name);
      if (index != -1) {
        saved[index] = c; // replace already existing old cookie
      } else {
        saved.add(c);
      }
    }

    final list = saved.map((c) => c.toString()).toList();
    await _prefs!.setStringList(key, list);

    handler.next(response);
  }
}
