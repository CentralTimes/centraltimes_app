class MediaModel {
  final int id;
  final String? caption;
  final String type;
  final double width;
  final double height;
  final String url;

  MediaModel(
      {required this.id,
      required this.url,
      required this.type,
      required this.width,
      required this.height,
      this.caption});

  @override
  String toString() {
    return 'MediaModel{id: $id, caption: $caption, type: $type, width: $width, height: $height, url: $url}';
  }
}
