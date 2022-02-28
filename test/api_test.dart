import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hey/api/cookie_interceptor.dart';
import 'package:hey/model/login.dart';
import 'package:hey/api/api_client.dart';
import 'package:logger/logger.dart';

var logger = Logger();

void main() {
  test('API Login Logout test', () async {
    // TODO Create API provider
    var dio = Dio();
    dio.interceptors.add(CookieInterceptor());

    var api = ApiClient(dio);
    var res =
        await api.loginResponse(Login(username: 'test', password: 'Mr.Yoda67'));

    logger.i(jsonEncode(res.data.toJson()));

    var user = await api.getMe();

    assert(user.username == 'test');
    assert(user.email == 'test@hey.app');
    <String>[].isNotEmpty;

    await api.logout();
  });
}
