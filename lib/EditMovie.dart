import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:movie_man/Services/Authentication.dart';
import 'package:movie_man/Services/Database.dart';

/// This widget is called on the Bottom Sheet when any list item is to be edited
class EditMovie extends StatefulWidget {
  EditMovie(
      {Key? key,
      required this.movieName,
      required this.directorName,
      required this.poster,
      required this.index})
      : super(key: key);
  final String movieName, directorName;
  final File poster;
  final int index;
  @override
  _EditMovieState createState() => _EditMovieState();
}

class _EditMovieState extends State<EditMovie> {
  final formKey = GlobalKey<FormState>();

  /// Picks Image using the ImagePicker library and sets [file] to
  /// the picked image
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

  String? updatedMovieName, updatedDirectorName;
  String errorMessage = "";
  @override
  Widget build(BuildContext context) {
    if (updatedMovieName == null) {
      updatedMovieName = widget.movieName;
      updatedDirectorName = widget.directorName;
      file = widget.poster;
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
              "Edit Movie",
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
                borderRadius: BorderRadius.circular(100),
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
                      initialValue: updatedMovieName,
                      decoration:
                          InputDecoration(labelText: "Enter Name of Movie"),
                      onChanged: (value) => updatedMovieName = value,
                      validator: (value) => value == ""
                          ? "Movie Name cannot be blank"
                          : Hive.box<MovieModel>(
                                      Authentication.auth.currentUser!.uid)
                                  .values
                                  .any((element) =>
                                      element.movieName.trim().toLowerCase() ==
                                          updatedMovieName!
                                              .trim()
                                              .toLowerCase() &&
                                      updatedMovieName!.trim().toLowerCase() !=
                                          widget.movieName.trim().toLowerCase())
                              ? "Movie Already Exists"
                              : null,
                    ),
                    TextFormField(
                      initialValue: updatedDirectorName,
                      decoration:
                          InputDecoration(labelText: "Enter Name of Director"),
                      onChanged: (value) => updatedDirectorName = value,
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
                  DatabaseServices.updateMovie(widget.index, updatedMovieName!,
                      updatedDirectorName!, file!);
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                }
              },
              child: Text("Submit")),
        ],
      ),
    );
  }
}
