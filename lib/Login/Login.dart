import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:movie_man/Services/Authentication.dart';

/// Login Page which shows the Movie Man Banner and Login Button
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          Image.asset("assets/images/MovieManLogo.png"),
          Center(
              child: SignInButton(
            Buttons.GoogleDark,
            text: "Continue With Google",
            onPressed: () {
              Authentication.signInWithGoogle();
            },
          )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
        ],
      ),
    );
  }
}
