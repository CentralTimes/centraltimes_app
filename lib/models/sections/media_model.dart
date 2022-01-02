import 'package:app/models/sections/section_model.dart';

class MediaModel extends SectionModel {
  final int id;
  final String type;
  final double width;
  final double height;
  final String url;
  final String? caption;

  MediaModel(
      {required this.id,
      required this.url,
      required this.type,
      required this.width,
      required this.height,
      this.caption});

  MediaModel.withCaption(
      {required MediaModel mediaModel, required this.caption})
      : id = mediaModel.id,
        type = mediaModel.type,
        width = mediaModel.width,
        height = mediaModel.height,
        url = mediaModel.url;

  @override
  String toString() {
    return 'MediaModel{id: $id, type: $type, width: $width, height: $height, url: $url, caption: $caption}';
  }
}
