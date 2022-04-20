class Endpoints {
  /// The base URL of the API
  static const baseUrl = "http://127.0.0.1:8080/api";

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

  // Profile picture
  static userPicture(String id) => "/users/$id/pfp";
  static const placeholderImage = 'https://flutter.github.io'
      '/assets-for-api-docs/assets/widgets/owl.jpg';
}
