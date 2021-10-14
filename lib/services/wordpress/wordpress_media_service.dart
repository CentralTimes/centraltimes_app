import 'package:app/ui/media_loading_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class WordpressMediaService {
  static late WordPressAPI api;
  static final Logger log = Logger("WordpressMediaService");

  // This cache shouldn't need to be cleared during app runtime, as media IDs
  // should be intrinsically linked to its API metadata and content.
  // Because of this we may want to TODO convert memory cache to local storage.
  static final Map<int, WPResponse> mediaCache = {};

  static void init(WordPressAPI api) {
    WordpressMediaService.api = api;
    log.info("Initialized!");
  }

  static FutureBuilder<WPResponse> getImage(
      int id,
      Widget Function(BuildContext, ImageProvider) builder,
      Widget Function(BuildContext, String) placeholder) {
    return FutureBuilder(
      future: _getMedia(id),
      builder: (context, res) {
        if (res.connectionState == ConnectionState.done && !res.hasError) {
          return CachedNetworkImage(
            imageUrl: res.data!.data.sourceUrl,
            imageBuilder: builder,
            placeholder: placeholder,
            fit: BoxFit.contain,
          );
        } else {
          return const MediaLoadingIndicator();
        }
      },
    );
  }

  static Future<WPResponse> _getMedia(id) async {
    if (mediaCache.containsKey(id)) {
      log.info("Media cache hit (id: $id)!");
      return mediaCache[id]!;
    } else {
      log.info("Retrieving media data for media $id...");
      WPResponse media = await WordpressMediaService.api.media.fetch(id: id);
      mediaCache[id] = media;
      return media;
    }
  }
}
