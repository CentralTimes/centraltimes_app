import 'package:app/models/gallery_image_model.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class CtSnoGalleryService {
  static late WordPressAPI api;
  static final Logger log = Logger("CtSnoGalleryService");

  static void init(WordPressAPI api) {
    CtSnoGalleryService.api = api;
    log.info("Initialized!");
  }

  static Future<List<GalleryImageModel>> getGalleryImageData(
      List<int> ids) async {
    final WPResponse res = await CtSnoGalleryService.api
        .fetch('sno-gallery/${ids.join(",")}', namespace: 'centraltimes/v1');

    List<GalleryImageModel> result = [];

    for (Map<String, dynamic> mediaMap in res.data) {
      result.add(_galleryImageFromMap(mediaMap));
    }

    return result;
  }

  static GalleryImageModel _galleryImageFromMap(Map<String, dynamic> mediaMap) {
    return GalleryImageModel(mediaMap["ID"].toString(),
        mediaMap["post_excerpt"], mediaMap["post_excerpt"], mediaMap["guid"]);
  }
}
