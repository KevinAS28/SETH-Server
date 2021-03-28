import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:sethcapp/domain/user.dart';
import 'package:sethcapp/providers/auth.dart';
import 'package:sethcapp/providers/user_provider.dart';
import 'package:sethcapp/util/validators.dart';
import 'package:sethcapp/util/widgets.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = new GlobalKey<FormState>();

  String _username, _password, _confirmPassword, _nik, _email, _phone, _bday;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final usernameField = TextFormField(
      autofocus: false,
      onSaved: (value) => _username = value,
      decoration: buildInputDecoration("Fill Username", Icons.person_search),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) => value.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _password = value,
      decoration: buildInputDecoration("Confirm password", Icons.lock),
    );

    final confirmPassword = TextFormField(
      autofocus: false,
      validator: (value) => value.isEmpty ? "Your password is required" : null,
      onSaved: (value) => _confirmPassword = value,
      obscureText: true,
      decoration: buildInputDecoration("Confirm password", Icons.lock),
    );

    final nikField = TextFormField(
      autofocus: false,
      onSaved: (value) => _nik = value,
      decoration: buildInputDecoration("Fill NIK", Icons.person_pin_rounded)
    );

    // final emailField = TextFormField(
    //   autofocus: false,
    //   onSaved: (value) => _email = value,
    //   decoration: buildInputDecoration("Fill Email", Icons.email),
    // );

    // final phoneField = TextFormField(
    //   autofocus: false,
    //   onSaved: (value) => _phone = value,
    //   decoration: buildInputDecoration("Fill Email", Icons.phone),
    // );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Registering ... Please wait")
      ],
    );

    var doRegister = () {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        auth.register(_username, _password, _confirmPassword, _nik).then((response) {
          print('response: $response');
          if (response['status']) {
            var data = response['data'];
            print('userData: ${data.toString()}');
            // User userData = data;
            User user = new User(nik: data.nik, username: data.username, password: data.password);
            print('setUser...');
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            print('dashboard...');
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else {
            Flushbar(
              title: "Registration Failed",
              message: response.toString(),
              duration: Duration(seconds: 10),
            ).show(context);
          }
        });
      } else {
        Flushbar(
          title: "Invalid form",
          message: "Please Complete the form properly",
          duration: Duration(seconds: 10),
        ).show(context);
      }
    };

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Center(
                    child: Container(
                        width: 150,
                        height: 150,
                        child: Image.asset('assets/images/logo.png')),
                  ),
                ),
                SizedBox(height: 15.0),
                label("Username"),
                SizedBox(height: 5.0),
                usernameField,
                SizedBox(height: 15.0),
                label("Password"),
                SizedBox(height: 10.0),
                passwordField,
                SizedBox(height: 15.0),
                label("Confirm Password"),
                SizedBox(height: 10.0),
                confirmPassword,
                SizedBox(height: 15.0),
                label("NIK (National Identity Card)"),
                SizedBox(height: 5.0),
                nikField,
                SizedBox(height: 15.0),
                // label("E-mail"),
                // SizedBox(height: 5.0),
                // emailField,
                // SizedBox(height: 15.0),
                // label("Phone"),
                // SizedBox(height: 5.0),
                // phoneField,
                // SizedBox(height: 15.0),


                auth.loggedInStatus == Status.Authenticating
                    ? loading
                    : longButtons("Register", doRegister),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
