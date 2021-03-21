class AppUrl {
  static const String liveBaseURL = "http://192.168.100.9:8000/c_api";
  static const String localBaseURL = "http://192.168.100.9:8000/c_api";

  static const String baseURL = liveBaseURL;
  static const String login = baseURL + "/get_user";
  static const String register = baseURL + "/register";
  static const String forgotPassword = baseURL + "/forgot-password";
}
