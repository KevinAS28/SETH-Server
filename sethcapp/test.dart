
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

void cert() async{
  var url = "http://127.0.0.1:8000/c_api/find_places_model";
  Map<String, dynamic> data = { "place": "Purwokerto Station"};
  Map<String, dynamic> response = await hitApiAuth(url, data);
  List<List<String>> requiredCerts = [];
  List<List<String>> notRequiredCerts = [];
  for (var rc in response["require_certs"]){
    for (var pl in rc.keys){
      requiredCerts.add([pl, rc[pl].join(" / ")]);
    }
  }
  

  for (var rc in response["not_required_certs"]){
    for (var pl in rc.keys){
      notRequiredCerts.add([pl, rc[pl].join(" / ")]);
    }
  }  

  print(requiredCerts);  
}


void cert1() async{
  var url = "http://127.0.0.1:8000/c_api/find_places_model";
  Map<String, dynamic> data = { "place": "USA"};
  Map<String, dynamic> response = await hitApiAuth(url, data);

    if (response["status"]=="OK"){
      List<List<String>> requiredCerts = [];
      List<List<String>> notRequiredCerts = [];
      for (var rc in response["require_certs"]){
        for (var pl in rc.keys){
          requiredCerts.add([pl, rc[pl].join(" / ")]);
        }
      }
      

      for (var rc in response["not_required_certs"]){
        for (var pl in rc.keys){
          notRequiredCerts.add([pl, "No Certificate Needed"]);
        }
      }  
    }
}

void get_certificates() async{
  var url = "http://127.0.0.1:8000/c_api/get_certificates";
  Map<String, dynamic> data = { "nik": "30919873421"};
  Map<String, dynamic> response = await hitApiAuth(url, data);
  // print(response);
  for (List<dynamic> list in response['certs']){
    print(list[0] + "\n\n");
  }
  
}

void cert_aplaces() async{
  var url = "http://127.0.0.1:8000/c_api/cert_bplaces";
  Map<String, dynamic> data = { "cert_name": "Genose"};
  Map<String, dynamic> response = await hitApiAuth(url, data);
  // print(response);
  for (String ap in response['aplaces']){
    print(ap + "\n\n");
  }
  
}


void main() async {
  // var url = "http://127.0.0.1:8000/c_api/place_input";
  // Map<String, dynamic> data = { "filter": "Gadjah Mada"};
  // Map<String, dynamic> response = await hitApiAuth(url, data);
  // print(response["predictions"][0]["description"]);
  cert_aplaces();
}

