import 'package:app/models/sections/section_model.dart';

class ImageModel extends SectionModel {
  final int id;
  final String? caption;

  const ImageModel({required this.id, this.caption});

  @override
  String toString() {
    return 'ImageModel{id: $id, caption: $caption}';
  }
}
