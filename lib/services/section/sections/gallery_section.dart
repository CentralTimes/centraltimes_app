import 'dart:math';

import 'package:app/models/ngg_image_model.dart';
import 'package:app/services/ct/ct_ngg_gallery_service.dart';
import 'package:app/services/section/article_section.dart';
import 'package:app/services/section/parser/shortcode_parser_service.dart';
import 'package:app/ui/media_loading_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class GallerySection implements ArticleSection {
  @override
  Widget useShortcode(Shortcode shortcode) {
    assert(shortcode.name == 'ngg');

    return Gallery(galleryId: int.parse(shortcode.arguments["ids"] ?? "0"));
  }
}

class Gallery extends StatefulWidget {
  final int galleryId;

  const Gallery({Key? key, required this.galleryId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GalleryState(galleryId);
}

class _GalleryState extends State<Gallery> {
  final int galleryId;

  int imageIndex = 0;

  List<NggImageModel> imageData = [];
  List<CachedNetworkImage> images = [];

  _GalleryState(this.galleryId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NggImageModel>>(
      future: CtNggGalleryService.getGalleryImageData(galleryId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          imageData = snapshot.data!;
          for (NggImageModel nggImage in imageData) {
            images.add(CachedNetworkImage(
                imageUrl: CtNggGalleryService.generateImageFileUrl(nggImage)));
          }
          return Column(
            children: [
              Text("Gallery"),
              Text("${imageIndex+1}/${imageData.length}"),
              Container(
                color: Colors.grey,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: images[imageIndex],
                ),
              ),
              Text(imageData[imageIndex].description),
              Row(
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          imageIndex = max(imageIndex - 1, 0);
                        });
                      },
                      icon: Icon(Icons.arrow_left),
                      label: Text("Previous")),
                  ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          imageIndex = min(imageIndex + 1, imageData.length - 1);
                        });
                      },
                      icon: Icon(Icons.arrow_right),
                      label: Text("Next")),
                ],
              )
            ],
          );
        } else {
          return MediaLoadingIndicator();
        }
      },
    );
  }
}
