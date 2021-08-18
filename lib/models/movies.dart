import 'package:hive/hive.dart';

part 'movies.g.dart';

@HiveType(typeId: 0)
class Movies extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String director;

  @HiveField(2)
  late String path;
}
