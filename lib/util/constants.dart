import 'package:dio/dio.dart';
import 'package:hey/api/api_client.dart';
import 'package:hey/api/cookie_interceptor.dart';
import 'package:hey/api/endpoints.dart';
import 'package:hey/api/location_service.dart';
import 'package:hey/util/log.dart';
import 'package:logger/logger.dart';
import 'package:hey/secret_consts.dart' as secret;

class Constants {
  Constants._();

  static final api = ApiClient(
    Dio()
      ..interceptors.addAll([
        CookieInterceptor(),
        LogInterceptor(logPrint: (msg) {
          Logger(printer: PlainPrinter()).d(msg);
        })
      ]),
    baseUrl: Endpoints.baseUrl,
  );

  static final locationService = LocationService(secret.mapsApiKey);
}
