import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class User {
  User({required this.name, required this.duration, required this.rating, required this.isSetup});

  @HiveField(0)
  String name;

  @HiveField(1)
  int duration;

  @HiveField(2)
  double rating;

  @HiveField(3)
   bool isSetup = false;

  @override
  String toString() {
    return '$name: your joke rating updates ever $duration day(s), you currently have a $rating joke rating';
  }
}