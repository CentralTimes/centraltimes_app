import 'dart:math';

import 'package:app/models/gallery_image_model.dart';
import 'package:app/services/ct/ct_ngg_gallery_service.dart';
import 'package:app/services/ct/ct_sno_gallery_service.dart';
import 'package:app/services/section/article_section.dart';
import 'package:app/services/section/parser/shortcode_parser_service.dart';
import 'package:app/ui/media_loading_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class GallerySection implements ArticleSection {
  @override
  Widget useShortcode(Shortcode shortcode) {
    assert(shortcode.name == 'ngg' || shortcode.name == 'gallery');

    Future<List<GalleryImageModel>> galleryImagesFuture;

    switch (shortcode.name) {
      case "ngg": // NextGEN Gallery
        galleryImagesFuture = CtNggGalleryService.getGalleryImageData(
            int.parse(shortcode.arguments["ids"] ?? "0"));
        break;
      case "gallery": // SNO Gallery
        galleryImagesFuture = CtSnoGalleryService.getGalleryImageData(
            (shortcode.arguments["ids"] ?? "")
                .split(",")
                .map((e) => int.parse(e.trim()))
                .toList());
        break;
      default:
        throw AssertionError();
    }

    return FutureBuilder<List<GalleryImageModel>>(
        future: galleryImagesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Gallery(galleryImages: snapshot.data!);
          } else {
            return MediaLoadingIndicator();
          }
        });
  }
}

class Gallery extends StatefulWidget {
  final List<GalleryImageModel> galleryImages;

  const Gallery({Key? key, required this.galleryImages}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GalleryState(galleryImages);
}

class _GalleryState extends State<Gallery> {
  final List<GalleryImageModel> galleryImages;

  int imageIndex = 0;

  List<CachedNetworkImage> images = [];

  _GalleryState(this.galleryImages);

  @override
  Widget build(BuildContext context) {
    for (GalleryImageModel galleryImage in galleryImages) {
      images.add(CachedNetworkImage(imageUrl: galleryImage.url));
    }
    return Column(
      children: [
        Text("Gallery"),
        Text("${imageIndex + 1}/${galleryImages.length}"),
        Container(
          color: Colors.grey,
          child: AspectRatio(
            aspectRatio: 1,
            child: images[imageIndex],
          ),
        ),
        Text(galleryImages[imageIndex].caption),
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
                    imageIndex = min(imageIndex + 1, galleryImages.length - 1);
                  });
                },
                icon: Icon(Icons.arrow_right),
                label: Text("Next")),
          ],
        )
      ],
    );
  }
}
