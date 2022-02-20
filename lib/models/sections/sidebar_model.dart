import 'package:app/models/sections/section_model.dart';

class SidebarModel extends SectionModel {
  final String title;
  final String? rating;
  final String? time;
  final String? where;

  const SidebarModel({required this.title, this.rating, this.time, this.where});

  @override
  String toString() {
    return stripHtmlIfNeeded(title);
  }

  String stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }
  /*
  @override
  String toString() {
    return 'SidebarModel{name: $title, rating: $rating, time: $time, where: $where}';*/
 // }
}
