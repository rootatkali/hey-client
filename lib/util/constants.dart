import 'package:dio/dio.dart';
import 'package:hey/api/api_client.dart';
import 'package:hey/api/cookie_interceptor.dart';

class Constants {
  static final api = ApiClient(Dio()..interceptors.add(CookieInterceptor()));
}
