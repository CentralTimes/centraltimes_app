import 'dart:math';

import 'package:app/models/media_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MediaImageWidget extends StatelessWidget {
  final MediaModel mediaModel;
  const MediaImageWidget({Key? key, required this.mediaModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: mediaModel.url,
        imageBuilder: (context, imageProvider) {
          return Ink.image(
              image: imageProvider,
              width: min(mediaModel.width, MediaQuery.of(context).size.width),
              height:
                  min(mediaModel.height, MediaQuery.of(context).size.width) *
                      mediaModel.height /
                      mediaModel.width);
        });
  }
}
