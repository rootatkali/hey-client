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

  // Interests
  static const getInterests = "/interests";

}

