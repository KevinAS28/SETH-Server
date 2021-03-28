import 'package:sethcapp/util/api.dart';
// Future<Map<String, dynamic>> hitApi (String url, Map<String, dynamic> data) async{

//     data["username"] = "cuser0";
//     data["password"] = "123450";

//     Response response = await post(
//       url,
//       body: json.encode(data),

//     );

//     final Map<String, dynamic> responseData = json.decode(response.body);
//     return responseData;
// }

void cert() async {
  var url = "http://127.0.0.1:8000/c_api/find_places_model";
  Map<String, dynamic> data = {"place": "Purwokerto Station"};
  Map<String, dynamic> response = await hitApiAuth(url, data);
  List<List<String>> requiredCerts = [];
  List<List<String>> notRequiredCerts = [];
  for (var rc in response["require_certs"]) {
    for (var pl in rc.keys) {
      requiredCerts.add([pl, rc[pl].join(" / ")]);
    }
  }

  for (var rc in response["not_required_certs"]) {
    for (var pl in rc.keys) {
      notRequiredCerts.add([pl, rc[pl].join(" / ")]);
    }
  }

  print(requiredCerts);
}

void cert1() async {
  var url = "http://127.0.0.1:8000/c_api/find_places_model";
  Map<String, dynamic> data = {"place": "USA"};
  Map<String, dynamic> response = await hitApiAuth(url, data);

  if (response["status"] == "OK") {
    List<List<String>> requiredCerts = [];
    List<List<String>> notRequiredCerts = [];
    for (var rc in response["require_certs"]) {
      for (var pl in rc.keys) {
        requiredCerts.add([pl, rc[pl].join(" / ")]);
      }
    }

    for (var rc in response["not_required_certs"]) {
      for (var pl in rc.keys) {
        notRequiredCerts.add([pl, "No Certificate Needed"]);
      }
    }
  }
}

void get_certificates() async {
  var url = "http://127.0.0.1:8000/c_api/get_certificates";
  Map<String, dynamic> data = {"nik": "30919873421"};
  Map<String, dynamic> response = await hitApiAuth(url, data);
  // print(response);
  for (List<dynamic> list in response['certs']) {
    print(list[0] + "\n\n");
  }
}

void cert_aplaces() async {
  var url = "http://127.0.0.1:8000/c_api/cert_bplaces";
  Map<String, dynamic> data = {"cert_name": "Genose"};
  Map<String, dynamic> response = await hitApiAuth(url, data);
  // print(response);
  for (String ap in response['aplaces']) {
    print(ap + "\n\n");
  }
}

Future<List<String>> findAplaces(name) async {
  print('findAplaces() called');
  // User user = Provider.of<UserProvider>(context, listen: false).user;
  Map<String, String> data = {"aplace_name": name};
  var response =
      await hitApiAuth("http://127.0.0.1:8000/c_api/find_aplaces", data);
  List<dynamic> listItems0 = response["aplaces"];
  List<String> listItems = [];
  for (var i in listItems0) {
    listItems.add(i as String);
  }
  return listItems;
}

Future<List<List<String>>> getHistory() async {
  print('getHistory() called');
  Map<String, String> data = {"nik": "30919873421"};
  var response = await hitApiAuth("http://127.0.0.1:8000/c_api/history_a", data);
  List<List<String>> history = [];
  for (var i in response["history"]) {
    history.add([i[0], i[1], i[2]]);
  }
  return history;
}

Future<List<String>> register() async {
  print('register() called');
  Map<String, String> data = {"nik": "3091987342111", "username": "h00", "password": "4321"};
  var response = await hitApi("http://127.0.0.1:8000/c_api/register", data);
  List<String> user = [];
  print(response);

  return user;
}

void main() async {
  var url = "http://127.0.0.1:8000/c_api/place_input";
  Map<String, dynamic> data = { "filter": "Gadjah Mada"};
  Map<String, dynamic> response = await hitApiAuth(url, data);
  print(response["predictions"][0]);
  // register();
  // print(('x' as String));
}
