import 'package:flutter/material.dart';
import 'package:movie_man/Services/Authentication.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Login with Google"),
          onPressed: () {
            Authentication.signInWithGoogle();
          },
        ),
      ),
    );
  }
}
