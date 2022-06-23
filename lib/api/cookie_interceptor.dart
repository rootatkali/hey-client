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
      // find cookie in list - name and domain match
      final index = saved.indexWhere((s) =>
          s.cookie.name == c.cookie.name && s.cookie.domain == c.cookie.domain);

      final empty = c.cookie.value.isEmpty;

      if (index != -1) {
        // old cookie exists
        if (empty) {
          saved.removeAt(index); // remove cookie if empty
        } else {
          saved[index] = c; // replace old cookie if not empty
        }
      } else if (!empty) {
        saved.add(c); // append to list, if not empty
      }
    }

    final list = saved.map((c) => c.toString()).toList();

    // remove key if list empty - see ui/HomePage#initState for reason
    if (list.isNotEmpty) {
      await _prefs!.setStringList(key, list);
    } else {
      await _prefs!.remove(key);
    }

    handler.next(response);
  }

  Future<String> fetchAuth() async {
    _prefs ??= await SharedPreferences.getInstance();
    final cookies = _prefs!.getStringList(key)!
    .map((e) => SerializableCookie.fromJson(e).cookie).toList();

    return cookies.firstWhere((c) => c.name == 'token').value;
  }
}
