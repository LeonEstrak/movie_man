import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_man/Home/HomePage.dart';
import 'package:movie_man/Services/Database.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MovieModelAdapter());

  await Hive.openBox<MovieModel>('data');
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green, canvasColor: Colors.white),
      home: CheckAuthentication(),
    );
  }
}

class CheckAuthentication extends StatelessWidget {
  const CheckAuthentication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
