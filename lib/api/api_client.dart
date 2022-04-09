import 'package:dio/dio.dart' hide Headers;
import 'package:hey/api/endpoints.dart';
import 'package:hey/model/login.dart';
import 'package:hey/model/mashov_login.dart';
import 'package:hey/model/school.dart';
import 'package:hey/model/user.dart';
import 'package:hey/model/user_registration.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: Endpoints.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // Auth
  @POST(Endpoints.createUser)
  @Headers(<String, dynamic>{
    "Content-Type": "application/json"
  })
  Future<User> createUser(@Body() UserRegistration registration);

  @POST(Endpoints.login)
  @Headers(<String, dynamic>{
    "Content-Type": "application/json"
  })
  Future<User> login(@Body() Login login);

  @POST(Endpoints.login)
  @Headers(<String, dynamic>{
    "Content-Type": "application/json"
  })
  Future<HttpResponse<User>> loginResponse(@Body() Login login);

  @POST(Endpoints.logout)
  Future<void> logout();

  @GET(Endpoints.getMe)
  Future<User> getMe();

  @PATCH(Endpoints.editMe)
  @Headers(<String, dynamic>{
    "Content-Type": "application/json"
  })
  Future<User> editMe(@Body() User edit);

  @GET(Endpoints.getUsers)
  Future<List<User>> getUsers();

  @GET(Endpoints.getUser)
  Future<User> getUser(@Path() String id);

  @GET(Endpoints.getSchools)
  Future<List<School>> getSchools();

  @GET(Endpoints.isVerified)
  Future<bool> isVerified();

  @POST(Endpoints.verifyMashov)
  @Headers(<String, dynamic>{
    "Content-Type": "application/json"
  })
  Future<User> verifyMashov(@Body() MashovLogin login);
}
