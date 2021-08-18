import 'package:and_cut/models/movies.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<Movies> getMovies() => Hive.box<Movies>('movies');
}
