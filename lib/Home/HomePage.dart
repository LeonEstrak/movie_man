import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_man/AddMovie.dart';
import 'package:movie_man/Home/Drawer/Drawer.dart';
import 'package:movie_man/Home/MovieItemCard.dart';
import 'package:movie_man/Services/Authentication.dart';
import 'package:movie_man/Services/Database.dart';

/// The Home Page which builds on a Scaffold, has a Drawer and a BottomSheet
/// Shows the List of all the Movies that have been registered
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  /// Since multiple Columns/ListViews exist in nested format, a single
  /// controller widget is used for all of them, combining all of them into a
  /// single scrollable Widget
  final controller = ScrollController();

  /// Scaffold Key used for opening and clossing the drawer
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

            /// Waits for the Hive box to open
            FutureBuilder(
                future: Hive.openBox<MovieModel>(
                    Authentication.auth.currentUser!.uid),
                builder: (context, AsyncSnapshot<Box<MovieModel>> snapshot) {
                  if (snapshot.hasData) {
                    Box<MovieModel> box = snapshot.data!;

                    /// Listens to all the changes made to box and updates everytime
                    return ValueListenableBuilder(
                        valueListenable: box.listenable(),
                        builder:
                            (BuildContext context, Box<MovieModel> box, _) {
                          if (box.length == 0) {
                            return Center(
                              child: Text(
                                "No Movies Added yet",
                                style: TextStyle(
                                    fontSize: 20, fontStyle: FontStyle.italic),
                              ),
                            );
                          }

                          /// Since the requirement was to create a list that is scrollable
                          /// infinitely, builder was used, since it calls the build methods
                          /// only when the object is visible on the screen. #optimization
                          return ListView.builder(
                              padding: EdgeInsets.all(10),
                              controller: widget.controller,
                              shrinkWrap: true,
                              itemCount: box.length,
                              itemBuilder: (BuildContext buildContext,
                                      int index) =>
                                  MovieItemCard(
                                      index: index,
                                      movieName:
                                          "${box.getAt(index)!.movieName}",
                                      directorName:
                                          "${box.getAt(index)!.directorName}",
                                      posterURL: box.getAt(index)!.posterPath));
                        });
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }

                  return Center(child: CircularProgressIndicator());
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
    );
  }
}
