import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_man/AddMovie.dart';
import 'package:movie_man/Home/MovieItemCard.dart';
import 'package:movie_man/Services/Database.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  final controller = ScrollController();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          controller: widget.controller,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Movie Man",
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ValueListenableBuilder(
                valueListenable: Hive.box<MovieModel>("data").listenable(),
                builder: (BuildContext context, Box<MovieModel> box, _) {
                  if (box.length == 0) {
                    return Center(
                      child: Text("Empty"),
                    );
                  }
                  return ListView.builder(
                      controller: widget.controller,
                      shrinkWrap: true,
                      itemCount: box.length,
                      itemBuilder: (BuildContext buildContext, int index) =>
                          MovieItemCard(
                              index: index,
                              movieName: "${box.getAt(index)!.movieName}",
                              directorName: "${box.getAt(index)!.directorName}",
                              posterURL: box.getAt(index)!.posterPath));
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30))),
              builder: (context) => AddMovie(),
            );
          });
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
