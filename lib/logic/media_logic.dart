import 'package:app/models/sections/media_model.dart';
import 'package:app/services/wordpress/wp_media_service.dart';

class MediaLogic {
  final Map<int, MediaModel> _mediaCache;
  MediaLogic() : _mediaCache = {};
  Future<MediaModel> getMediaSingle(int id) async {
    if (_mediaCache.containsKey(id)) {
      return _mediaCache[id]!;
    }
    MediaModel media = await WordpressMediaService.fetchMedia(id: id);
    _mediaCache[id] = media;
    return media;
  }

  Future<List<MediaModel>> getMedia(List<int> ids) {
    return Future.wait(ids.map((id) => getMediaSingle(id)));
  }

  MediaModel? getMediaFromCache(int id) {
    return _mediaCache[id];
  }
}
