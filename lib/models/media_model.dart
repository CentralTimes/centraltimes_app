class MediaModel {
  final String id;
  final String? caption;
  final String url;

  MediaModel({required this.id, required this.url, this.caption});

  @override
  String toString() {
    return 'GalleryImageModel{id: $id, caption: $caption, url: $url}';
  }
}
