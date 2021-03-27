import 'package:sethcapp/domain/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("userId", user.id);
    prefs.setString("name", user.name);
    prefs.setString("nik", user.nik);
    prefs.setString("email", user.email);
    prefs.setString("phone", user.phone);
    prefs.setString("username", user.username);
    prefs.setString("password", user.password);

    return prefs.commit();
  }

  Future<bool> saveUserMinimal(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("nik", user.nik);
    prefs.setString("username", user.username);
    prefs.setString("password", user.password);

    return prefs.commit();
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt("userId");
    String name = prefs.getString("name");
    String nik = prefs.getString("nik");
    String email = prefs.getString("email");
    String phone = prefs.getString("phone");
    String username = prefs.getString("username");
    String password = prefs.getString("password");

    return User(
        id: userId,
        name: name,
        email: email,
        phone: phone,
        username: username,
        password: password,
    );
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("name");
    prefs.remove("email");
    prefs.remove("phone");
    prefs.remove("nik");
    prefs.remove("username");
    prefs.remove("password");
  }

  Future<String> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return token;
  }
  
  Future<String> getPassword(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String password = prefs.getString("password");
    return password;
  }  
}
