import 'package:dio/dio.dart' hide Headers;
import 'package:hey/api/encryption.dart';
import 'package:hey/api/endpoints.dart';
import 'package:hey/model/chat_message.dart';
import 'package:hey/model/friend_view.dart';
import 'package:hey/model/interest.dart';
import 'package:hey/model/latlon.dart';
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
  Future<User> editMe(@Body(nullToAbsent: true) User edit);

  @GET(Endpoints.getLocation)
  Future<LatLon> getMyLocation();

  @POST(Endpoints.setLocation)
  @Headers(<String, dynamic>{
    "Content-Type": "application/json"
  })
  Future<LatLon> postLocation(@Body() LatLon location);

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

  @POST(Endpoints.manualSchool)
  @Headers(<String, dynamic>{
    "Content-Type": "application/json"
  })
  Future<User> manuallySetSchool(@Body() School school);

  @GET(Endpoints.getInterests)
  Future<List<Interest>> getInterests();

  @POST(Endpoints.addInterest)
  @Headers(<String, dynamic>{
    "Content-Type": "application/json"
  })
  Future<Interest> addInterest(@Body() String name);

  @GET(Endpoints.getMyInterests)
  Future<List<Interest>> getMyInterests();

  @PUT(Endpoints.setMyInterests)
  @Headers(<String, dynamic>{
    "Content-Type": "application/json"
  })
  Future<List<Interest>> setMyInterests(@Body() List<Interest> interests);

  @GET(Endpoints.getMatches)
  Future<List<FriendView>> getMatches();

  // Friends
  @GET(Endpoints.getFriends)
  Future<List<FriendView>> getFriends();

  @GET(Endpoints.getPendingRequests)
  Future<List<FriendView>> getPendingFriendRequests();

  @POST(Endpoints.postFriendRequest)
  Future<FriendView> requestFriend(@Path() String friend);

  @DELETE(Endpoints.deleteFriendRequest)
  Future<FriendView> deleteRequest(@Path() String friend);

  @PUT(Endpoints.approveFriendRequest)
  Future<FriendView> approveFriendRequest(@Path() String friend);

  @PUT(Endpoints.rejectFriendRequest)
  Future<FriendView> rejectFriendRequest(@Path() String friend);

  // Key
  @POST(Endpoints.storeKey)
  @Headers(<String, dynamic>{
    "Content-Type": "application/json"
  })
  Future<PublicKey> storeKey(@Body() String jwk);

  @GET(Endpoints.retrieveKey)
  Future<String> retrieveKey(@Path() String user);

  // Chat
  @GET(Endpoints.getChatHistory)
  Future<List<Message>> getChatHistory(@Path() String friend);

  @GET(Endpoints.getMessage)
  Future<Message> getMessage(@Path() String id);
}
