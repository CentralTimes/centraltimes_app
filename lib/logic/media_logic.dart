import 'package:app/models/media_model.dart';
import 'package:app/services/wordpress/wp_media_service.dart';
import 'package:logging/logging.dart';

class MediaLogic {
  final Logger log = Logger("MediaManager");
  final Map<int, MediaModel> _mediaCache;
  MediaLogic() : _mediaCache = {};
  Future<MediaModel> getMediaSingle(int id) async {
    if (_mediaCache.containsKey(id)) {
      return _mediaCache[id]!;
    }
    MediaModel media = await WordpressMediaService.fetchMedia(id: id);
    _mediaCache[id] = media;
    //log.info(media);
    return media;
  }

  Future<List<MediaModel>> getMedia(List<int> ids) {
    return Future.wait(ids.map((id) => getMediaSingle(id)));
  }

  MediaModel? getMediaFromCache(int id) {
    return _mediaCache[id];
  }
}
