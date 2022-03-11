import 'package:dio/dio.dart';
import 'package:hey/api/api_client.dart';
import 'package:hey/api/cookie_interceptor.dart';
import 'package:hey/util/log.dart';
import 'package:logger/logger.dart';

class Constants {
  static final api = ApiClient(Dio()..interceptors.addAll([
    CookieInterceptor(),
    LogInterceptor(logPrint: (msg) {
      Logger(printer: PlainPrinter()).d(msg);
    })
  ]));
}
