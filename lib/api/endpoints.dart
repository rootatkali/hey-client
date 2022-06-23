import 'package:hey/model/friend_view.dart';
import 'package:hey/model/user.dart';

class Endpoints {
  Endpoints._();

  /// The base URL of the API
  static const baseUrl = "http://62.90.120.131:8080/api";
  static const socketUri = "http://62.90.120.131:8080/ws";

  // Users
  static const getUsers = "/users";
  static const getUser = "/users/{id}";
  static const createUser = "/users";
  static const login = "/login";
  static const getMe = "/me";
  static const editMe = "/me";
  static const getLocation = "/me/location";
  static const setLocation = "/me/location";
  static const logout = "/logout";

  // Verify
  static const getSchools = "/schools";
  static const isVerified = "/verify";
  static const verifyMashov = "/verify/mashov";
  static const manualSchool = "/verify/debug/school";

  // Interests
  static const getInterests = "/interests";
  static const addInterest = "/interests";
  static const getMyInterests = "/me/interests";
  static const setMyInterests = "/me/interests";

  // Match
  static const getMatches = "/match";

  // Friends
  static const getFriends = "/friends";
  static const getPendingRequests = "/friends/pending";
  static const postFriendRequest = "/friends/{friend}";
  static const deleteFriendRequest = "/friends/{friend}";
  static const approveFriendRequest = "/friends/{friend}/approve"; // PUT
  static const rejectFriendRequest = "/friends/{friend}/reject"; // PUT

  // Profile picture
  static userPicture(String id) => "/users/$id/pfp";
  static const placeholderImage = 'https://flutter.github.io'
      '/assets-for-api-docs/assets/widgets/owl.jpg';

  // Public key
  static const storeKey = "/key";
  static const retrieveKey = "/key/{user}";

  // Chat
  // WebSocket
  static messageQueue(User user, FriendView friend) => "/user/${user.id}/queue/messages/${friend.id}";
  static const sendMessage = "/app/chat";
  // HTTP
  static const getMessage = "/messages/{id}";
  static const getChatHistory = "/chats/{friend}";
}
