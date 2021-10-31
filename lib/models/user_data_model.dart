import 'dart:typed_data';

class User {
  final String name;
  final String gender;
  final int date;
  final int month;
  final int year;
  final Uint8List image;
  User({this.month, this.year, this.date, this.name, this.gender, this.image});
}
