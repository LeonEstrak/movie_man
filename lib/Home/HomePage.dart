import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_man/AddMovie.dart';
import 'package:movie_man/Home/Drawer/Drawer.dart';
import 'package:movie_man/Home/MovieItemCard.dart';
import 'package:movie_man/Services/Database.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  final controller = ScrollController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      drawer: Drawer(
        child: ProfileDrawer(scaffoldKey: widget.scaffoldKey),
      ),
      body: SafeArea(
        child: ListView(
          controller: widget.controller,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Stack(children: [
                SizedBox(
                  height: 50,
                  child: Align(
                    child: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        widget.scaffoldKey.currentState!.openDrawer();
                      },
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Image.asset("assets/images/MovieManTitle.png")),
                ),
              ]),
            ),
            ValueListenableBuilder(
                valueListenable: Hive.box<MovieModel>("data").listenable(),
                builder: (BuildContext context, Box<MovieModel> box, _) {
                  if (box.length == 0) {
                    return Center(
                      child: Text(
                        "No Movies Added yet",
                        style: TextStyle(
                            fontSize: 20, fontStyle: FontStyle.italic),
                      ),
                    );
                  }
                  return ListView.builder(
                      padding: EdgeInsets.all(10),
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
            // Authentication.signOut();
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
    );
  }
}
