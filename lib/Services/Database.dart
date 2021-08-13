import 'dart:io';
import 'package:path/path.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

part 'Database.g.dart';

class DatabaseServices {
  static void addMovie(
      String movieName, String directorName, File poster) async {
    Box<MovieModel> _hiveBox = Hive.box<MovieModel>("data");

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

  static void deleteMovie(int index) {
    Box<MovieModel> _hiveBox = Hive.box<MovieModel>("data");
    File file = File(_hiveBox.getAt(index)!.posterPath);
    file.delete();
    _hiveBox.deleteAt(index);
  }

  static void updateMovie(
      int index, String movieName, String directorName, File poster) async {
    Box<MovieModel> _hiveBox = Hive.box<MovieModel>("data");

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