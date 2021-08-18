import 'dart:io';

import 'package:and_cut/boxes.dart';
import 'package:and_cut/functions/db.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:and_cut/components/movies_list.dart';
import 'package:and_cut/models/movies.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  get onclickDone => null;

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ylw movies",
        ),
        backgroundColor: Colors.green,
      ),
      body: ValueListenableBuilder<Box<Movies>>(
        valueListenable: Boxes.getMovies().listenable(),
        builder: (context, box, _) {
          final movies = box.values.toList().cast<Movies>();

          return buildContent(movies);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text("Add"),
          backgroundColor: Colors.green,
          onPressed: () => showDialog(
                context: context,
                builder: (context) => MovieTransaction(
                  onclickDone: addMovie,
                ),
              )),
    );
  }

  Widget buildContent(List<Movies> movies) {
    if (movies.isEmpty) {
      return Center(
        child: Text(
          'Add your favorite movie now!!❤️',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          final movie = movies[index];
          return buildTransaction(context, movie);
        },
      );
    }
  }

  Widget buildTransaction(
    BuildContext context,
    Movies movies,
  ) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(color: Colors.black)),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          movies.name,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: Image.file(File(movies.path)),
        subtitle: Text("Directed By:" + movies.director),
        children: [
          buildButtons(context, movies),
        ],
      ),
    );
  }

  //buildbutton
  Widget buildButtons(BuildContext context, Movies movie) => Row(
        children: [
          Expanded(
            child: TextButton.icon(
              label: Text('Edit'),
              icon: Icon(Icons.edit),
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => MovieTransaction(
                      movie: movie,
                      onclickDone: (name, director, path) =>
                          editMovie(movie, name, director, path))),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              label: Text('Delete'),
              icon: Icon(Icons.delete),
              onPressed: () => deleteMovie(movie),
            ),
          )
        ],
      );

  //addmovie
  Future addMovie(String name, String director, String path) async {
    final movie = Movies()
      ..name = name
      ..director = director
      ..path = path;

    final box = Boxes.getMovies();
    box.add(movie);
  }

  //editmovie
  void editMovie(Movies movie, String name, String director, String path) {
    movie.name = name;
    movie.director = director;
    movie.path = path;

    movie.save();
  }

  //delete movie
  void deleteMovie(Movies movie) {
    movie.delete();
  }
}
