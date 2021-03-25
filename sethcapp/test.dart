
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

void main() async {
  // var url = "http://127.0.0.1:8000/c_api/place_input";
  // Map<String, dynamic> data = { "filter": "Gadjah Mada"};
  // Map<String, dynamic> response = await hitApiAuth(url, data);
  // print(response["predictions"][0]["description"]);
  cert1();
}