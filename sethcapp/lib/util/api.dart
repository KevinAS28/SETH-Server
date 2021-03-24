// import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'dart:convert';
// import 'package:provider/provider.dart';
import 'package:sethcapp/domain/user.dart';
// import 'package:sethcapp/providers/user_provider.dart';

Future<Map<String, dynamic>> hitApiAuth (String url, Map<String, dynamic> data, [String username="cuser0", String password="123450"]) async{

    
    data["username"] = username;
    data["password"] = password;


    Response response = await post(
      url,
      body: json.encode(data),
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    return responseData;
}

Future<Map<String, dynamic>> hitApiUs (User user, String url, Map<String, dynamic> data) async{
    var username = user.username;
    var password = user.password;
    return hitApiAuth(url, data, username, password);
}


