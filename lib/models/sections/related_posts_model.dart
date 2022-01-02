import 'package:app/models/sections/section_model.dart';

class RelatedPostsModel extends SectionModel {
  final List<int> storyIds;
  final String title;

  const RelatedPostsModel({required this.storyIds, required this.title});

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
