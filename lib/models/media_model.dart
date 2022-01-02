import 'package:app/models/object_model.dart';

class MediaModel extends ObjectModel {
  final String type;
  final double width;
  final double height;
  final String url;

  const MediaModel(
      {required this.type,
      required this.width,
      required this.height,
      required this.url});

  @override
  String toString() {
    return 'MediaModel{type: $type, width: $width, height: $height, url: $url}';
  }
}
