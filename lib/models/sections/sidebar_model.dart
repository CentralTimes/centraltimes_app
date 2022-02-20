import 'package:app/models/sections/section_model.dart';

class SidebarModel extends SectionModel {
  final String title;
  final String? rating;
  final String? time;
  final String? where;

  const SidebarModel({required this.title, this.rating, this.time, this.where});

  @override
  String toString() {
    // TODO: implement toString
    return title;
  }
  /*
  @override
  String toString() {
    return 'SidebarModel{name: $title, rating: $rating, time: $time, where: $where}';*/
 // }
}
