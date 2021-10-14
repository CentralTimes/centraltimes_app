class GalleryImageModel {
  final String id;
  final String caption;
  final String alt;

  final String url;

  GalleryImageModel(this.id, this.caption, this.alt, this.url);

  @override
  String toString() {
    return 'GalleryImageModel{id: $id, caption: $caption, alt: $alt, url: $url}';
  }
}
