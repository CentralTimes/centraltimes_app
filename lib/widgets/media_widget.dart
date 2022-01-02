import 'dart:math';

import 'package:app/models/sections/media_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MediaImageWidget extends StatelessWidget {
  final MediaModel media;
  const MediaImageWidget({Key? key, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: media.url,
        imageBuilder: (context, imageProvider) {
          return Ink.image(
              image: imageProvider,
              width: min(media.width, MediaQuery.of(context).size.width),
              height: min(media.height, MediaQuery.of(context).size.width) *
                  media.height /
                  media.width);
        });
  }
}
