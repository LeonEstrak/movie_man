import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_man/EditMovie.dart';
import 'package:movie_man/Services/Database.dart';

class MovieItemCard extends StatefulWidget {
  const MovieItemCard(
      {Key? key,
      required this.movieName,
      required this.directorName,
      required this.posterURL,
      required this.index})
      : super(key: key);

  final int index;
  final String movieName;
  final String directorName;
  final String posterURL;

  @override
  _MovieItemCardState createState() => _MovieItemCardState();
}

class _MovieItemCardState extends State<MovieItemCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.file(
            File(this.widget.posterURL),
            height: 90,
            width: 160,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                this.widget.movieName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Text(this.widget.directorName)
            ],
          ),
          Column(children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30))),
                      builder: (context) => EditMovie(
                          movieName: widget.movieName,
                          directorName: widget.directorName,
                          poster: File(widget.posterURL),
                          index: widget.index),
                    );
                  });
                },
                icon: Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("Delete ${widget.movieName} ?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    DatabaseServices.deleteMovie(widget.index);
                                    Navigator.of(context, rootNavigator: true)
                                        .pop('dialog');
                                  },
                                  child: Text("Yes")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop('dialog');
                                  },
                                  child: Text("No")),
                            ],
                          ));
                },
                icon: Icon(Icons.delete))
          ])
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3.0,
                blurRadius: 5.0)
          ]),
    );
  }
}
