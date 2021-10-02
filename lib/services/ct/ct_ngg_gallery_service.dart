import 'package:app/models/ngg_image_model.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class CtNggGalleryService {
  static WordPressAPI? api;
  static final Logger log = new Logger("CtNggGalleryService");

  static void init(WordPressAPI api) {
    CtNggGalleryService.api = api;
    log.info("Initialized!");
  }

  static Future<List<NggImageModel>> getGalleryImageData(int id) async {
    final WPResponse res = await CtNggGalleryService.api!
        .fetch('ngg-gallery/$id', namespace: 'centraltimes/v1');

    log.config(res);

    List<NggImageModel> result = [];
    for (Map<String, dynamic> nggImageMap in res.data) {
      result.add(_nggImageFromMap(nggImageMap));
    }

    return result;
  }

  static NggImageModel _nggImageFromMap(Map<String, dynamic> nggImageMap) {
    return new NggImageModel(
        nggImageMap["pid"],
        nggImageMap["image_slug"],
        nggImageMap["filename"],
        nggImageMap["description"],
        nggImageMap["alttext"],
        nggImageMap["path"]);
  }

  static String generateImageFileUrl(NggImageModel nggImage) {
    /*
    TODO we just do string concatenation here, and that's fine for now as the
     API seems to return consistent results, but something such as a uri join
     function would be more robust. Unfortunately the path library's join
     function isn't suited to this, as it uses the platform's separator instead
     of the one consistent to web URIs: "/".
     */
    return Uri.https(api!.site, nggImage.path + nggImage.filename).toString();
  }
}
