import 'package:app/models/section_model.dart';

class MediaModel extends SectionModel {
  final String type;
  final double width;
  final double height;
  final String url;
  final String? caption;

  MediaModel(
      {required int id,
      required this.url,
      required this.type,
      required this.width,
      required this.height,
      this.caption})
      : super(id: id);

  MediaModel.withCaption(
      {required MediaModel mediaModel, required this.caption})
      : type = mediaModel.type,
        width = mediaModel.width,
        height = mediaModel.height,
        url = mediaModel.url,
        super(id: mediaModel.id);

  @override
  String toString() {
    return 'MediaModel{id: $id, type: $type, width: $width, height: $height, url: $url, caption: $caption}';
  }
}
