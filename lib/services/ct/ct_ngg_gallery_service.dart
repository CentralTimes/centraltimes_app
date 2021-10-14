import 'package:app/models/gallery_image_model.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class CtNggGalleryService {
  static late WordPressAPI api;
  static final Logger log = Logger("CtNggGalleryService");

  static void init(WordPressAPI api) {
    CtNggGalleryService.api = api;
    log.info("Initialized!");
  }

  static Future<List<GalleryImageModel>> getGalleryImageData(int id) async {
    final WPResponse res = await CtNggGalleryService.api
        .fetch('ngg-gallery/$id', namespace: 'centraltimes/v1');

    log.config(res);

    List<GalleryImageModel> result = [];
    for (Map<String, dynamic> nggImageMap in res.data) {
      result.add(_galleryImageFromMap(nggImageMap));
    }

    return result;
  }

  static GalleryImageModel _galleryImageFromMap(
      Map<String, dynamic> nggImageMap) {
    return GalleryImageModel(
        nggImageMap["pid"],
        nggImageMap["description"],
        nggImageMap["alttext"],
        _generateImageFileUrl(nggImageMap["filename"], nggImageMap["path"]));
  }

  static String _generateImageFileUrl(String filename, String path) {
    /*
    TODO we just do string concatenation here, and that's fine for now as the
     API seems to return consistent results, but something such as a uri join
     function would be more robust. Unfortunately the path library's join
     function isn't suited to this, as it uses the platform's separator instead
     of the one consistent to web URIs: "/".
     */
    return Uri.https(api.site, path + filename).toString();
  }
}
