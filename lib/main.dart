import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_man/Home/HomePage.dart';
import 'package:movie_man/Login/Login.dart';
import 'package:movie_man/Services/Authentication.dart';
import 'package:movie_man/Services/Database.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  /// This is used to ensure that the connection exists between this top layer
  /// and the flutter engine where the native code resides
  WidgetsFlutterBinding.ensureInitialized();

  /// ALl of this below makes calls on native code
  await Hive.initFlutter();
  Hive.registerAdapter(MovieModelAdapter());
  await Hive.openBox<MovieModel>('data');

  /// This too
  await Firebase.initializeApp();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo, canvasColor: Colors.white),
      home: CheckAuthentication(),
    );
  }
}

/// Checks whether a user has logged in or not
/// If logged in , renders the HomePage
/// If not logged in , renders the LoginPage
class CheckAuthentication extends StatelessWidget {
  const CheckAuthentication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Uses StreamBuilder to keep real-time track of auth activities
    return StreamBuilder(
      stream: Authentication.auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        if (snapshot.hasData) {
          return HomePage();
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        }
        return Login();
      },
    );
  }
}
