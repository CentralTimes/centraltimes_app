import 'package:app/models/sections/section_model.dart';

class SidebarModel extends SectionModel {
  final String title;

  const SidebarModel({required this.title});

  @override
  String toString() {
    return title.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }
}
