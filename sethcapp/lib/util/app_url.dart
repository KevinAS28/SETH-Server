class AppUrl {
  static const String cApiUrl = "http://192.168.100.9:8000/c_api";
  static const String login = cApiUrl + "/get_user";
  static const String register = cApiUrl + "/register";
  static const String findPlacesModel = cApiUrl + "/find_places_model";
  static const String placeInput = cApiUrl + "/place_input";
  static const String getCertificates = cApiUrl + "/get_certificates";
  static const String certAplaces = cApiUrl + "/cert_aplaces";
  static const String findAplaces = cApiUrl + "/find_aplaces";
  static const String historyA = cApiUrl + "/history_a";

  static const String bApiUrl = "http://192.168.100.9:8000/b_web";
  static const String qr = bApiUrl + "/receive_qr";  
}
