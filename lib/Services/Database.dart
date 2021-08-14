import 'dart:io';
import 'package:movie_man/Services/Authentication.dart';
import 'package:path/path.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

/// Generated using Hive_Generator and build_runner
part 'Database.g.dart';

/// Contains all functions related to Database usage
class DatabaseServices {
  /// Hive Box instance
  static Box _hiveBox =
      Hive.box<MovieModel>(Authentication.auth.currentUser!.uid);

  /// Add Movie to the list in Hive
  /// Creates a new Hive Entry and copies the image file into a readily accessible
  /// location.
  static void addMovie(
      String movieName, String directorName, File poster) async {
    final String path =
        await getApplicationDocumentsDirectory().then((value) => value.path);
    final String filename = movieName + basename(poster.path);
    File newFile = await poster.copy(path + filename);

    MovieModel movieItem = MovieModel(
        movieName: movieName,
        directorName: directorName,
        posterPath: newFile.path);

    _hiveBox.add(movieItem);
  }

  /// Delete a Movie from the List, Deletes the image and then deletes the Hive entry.
  static void deleteMovie(int index) {
    File file = File(_hiveBox.getAt(index)!.posterPath);
    file.delete();
    _hiveBox.deleteAt(index);
  }

  /// Updates the Movie Item based on the Index position of the entry in Hive
  static void updateMovie(
      int index, String movieName, String directorName, File poster) async {
    final String path =
        await getApplicationDocumentsDirectory().then((value) => value.path);
    final String filename = movieName + basename(poster.path);
    File newFile = await poster.copy(path + filename);

    MovieModel movieItem = MovieModel(
        movieName: movieName,
        directorName: directorName,
        posterPath: newFile.path);

    _hiveBox.putAt(index, movieItem);
  }
}

/// The Movie Data Model that is used to store the data in Hive Database
///
/// Only add or remove the Field Values
///
/// Do not update the `typeId` or `HiveField` values unless you want to unleash chaos
@HiveType(typeId: 1)
class MovieModel {
  MovieModel(
      {required this.movieName,
      required this.directorName,
      required this.posterPath});

  @HiveField(0)
  String movieName;

  @HiveField(1)
  String directorName;

  @HiveField(2)
  String posterPath;
}
