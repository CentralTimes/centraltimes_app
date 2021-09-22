import 'package:app/ui/media_loading_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class WordpressMediaService {
  static WordPressAPI? api;
  static final Logger log = new Logger("WordpressMediaService");

  static void init(WordPressAPI api) {
    WordpressMediaService.api = api;
    log.info("Initialized!");
  }

  static FutureBuilder<WPResponse> getImage(id, builder, placeholder) {
    return new FutureBuilder(
      future: WordpressMediaService.api!.media.fetch(id: id),
      builder: (context, res) {
        if (res.connectionState == ConnectionState.done && !res.hasError)
          return new CachedNetworkImage(
            imageUrl: res.data!.data.sourceUrl,
            imageBuilder: builder,
            placeholder: placeholder,
          );
        else
          return new MediaLoadingIndicator();
      },
    );
  }
}
