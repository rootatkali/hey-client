import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hey/api/endpoints.dart';
import 'package:hey/model/login.dart';
import 'package:hey/api/api_client.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

var logger = Logger();

void main() {
  test('API Login Logout test', () async {
    // TODO turn this method into api provider
    // TODO create a working cookie store (shared prefs?)
    var appPath = (await getApplicationDocumentsDirectory()).path;
    logger.i(appPath);
    var dio = Dio();
    var cookieJar =
        PersistCookieJar(ignoreExpires: true, storage: FileStorage(appPath + '/.cookies/'));
    var token = '';
    dio.interceptors.add(CookieManager(cookieJar));
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      options.headers[HttpHeaders.cookieHeader] = token;
      handler.next(options);
    }));

    var api = ApiClient(dio);
    var res =
        await api.loginResponse(Login(username: 'test', password: 'Mr.Yoda67'));

    token = res.response.headers.value('Set-Cookie')?.split(';')[0] ?? '';

    logger.i(await cookieJar.loadForRequest(Uri.parse(Endpoints.baseUrl)));

    var user = await api.getMe();
    logger.i(jsonEncode(user.toJson()));

    assert(user.username == 'test');
    assert(user.email == 'test@hey.app');

    await api.logout();
  });
}
