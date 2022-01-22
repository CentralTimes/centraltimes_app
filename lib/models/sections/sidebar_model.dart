import 'package:app/models/sections/section_model.dart';

class SidebarModel extends SectionModel {
  final String? name;
  final String? rating;
  final String? time;
  final String? where;

  const SidebarModel({this.name, this.rating, this.time, this.where});

  @override
  String toString() {
    return 'SidebarModel{name: $name, rating: $rating, time: $time, where: $where}';
  }
}
