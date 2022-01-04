import 'package:app/models/media_model.dart';
import 'package:app/services/wordpress/wordpress_init.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class WordpressMediaService {
  static final Logger log = Logger("WordpressMediaService");

  static Future<MediaModel?> fetchMedia({required int id}) async {
    log.info("Retrieving media data for media $id...");
    try {
      WPResponse response = await wpApi.media.fetch(id: id);
      MediaModel media = MediaModel(
          url: response.data.mediaDetails["sizes"]["full"]["source_url"],
          type: response.data.mediaDetails["sizes"]["full"]["mime_type"],
          width:
              response.data.mediaDetails["sizes"]["full"]["width"].toDouble(),
          height:
              response.data.mediaDetails["sizes"]["full"]["height"].toDouble());
      return media;
    } catch (e) {
      log.info(e);
    }
  }
}
