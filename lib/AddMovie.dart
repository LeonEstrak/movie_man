import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_man/Services/Authentication.dart';
import 'package:movie_man/Services/Database.dart';

class AddMovie extends StatefulWidget {
  AddMovie({Key? key}) : super(key: key);
  @override
  _AddMovieState createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  final formKey = GlobalKey<FormState>();
  Future pickImage(ImageSource source) async {
    XFile? selected = await new ImagePicker().pickImage(source: source);
    setState(() {
      // ignore: unnecessary_null_comparison
      if (selected != null) {
        file = File(selected.path);
        print(selected.path);
      }
    });
  }

  File? file;
  Image defaultImage = Image.asset(
    "assets/images/addimage.png",
    fit: BoxFit.cover,
  );

  String movieName = "", directorName = "";
  String errorMessage = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width * 0.9,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                "Add Movie",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => pickImage(ImageSource.gallery),
              child: Container(
                height: 150,
                width: 150,
                clipBehavior: Clip.hardEdge,
                child: file != null
                    ? Image.file(
                        file!,
                        fit: BoxFit.cover,
                      )
                    : defaultImage,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black12,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: "Enter Name of Movie"),
                        onChanged: (value) => movieName = value,
                        validator: (value) => value == ""
                            ? "Movie Name cannot be blank"
                            : Hive.box<MovieModel>(
                                        Authentication.auth.currentUser!.uid)
                                    .values
                                    .any((element) =>
                                        element.movieName
                                            .trim()
                                            .toLowerCase() ==
                                        movieName.trim().toLowerCase())
                                ? "Movie Already Exists"
                                : null,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "Enter Name of Director"),
                        onChanged: (value) => directorName = value,
                      ),
                    ],
                  )),
            ),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
            ElevatedButton(
                onPressed: () {
                  if (file == null) {
                    setState(() {
                      errorMessage = "Add a Movie Poster";
                    });
                  } else if (formKey.currentState!.validate()) {
                    DatabaseServices.addMovie(movieName, directorName, file!);
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  }
                },
                child: Text("Submit")),
          ],
        ),
      ),
    );
  }
}
