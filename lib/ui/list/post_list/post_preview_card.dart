import 'dart:math';

import 'package:app/models/post_model.dart';
import 'package:app/services/wordpress/wordpress_media_service.dart';
import 'package:app/ui/save_button.dart';
import 'package:app/views/article_view.dart';
import 'package:app/views/featured_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wordpress_api/src/helpers.dart';

class PostPreviewCard extends StatelessWidget {
  final PostModel post;
  static const double blur = 1;

  PostPreviewCard({required this.post}) : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ArticleView(post))),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, blur),
              blurRadius: blur,
              spreadRadius: -2 * blur,
            ),
            BoxShadow(
              offset: Offset(0, -blur),
              blurRadius: blur,
              spreadRadius: -2 * blur,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.featuredMedia != 0) // 0 is no media
              Center(
                child: getFeaturedMedia(post.featuredMedia),
              ),
            Padding(padding: EdgeInsets.all(8)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(post.title, style: TextStyle(fontSize: 28))),
            if (post.staffNames.isNotEmpty) ...[
              Padding(padding: EdgeInsets.all(4)),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(post.writers.join(", "),
                      style: TextStyle(fontSize: 18))),
            ],
            if (post.excerpt != "") ...[
              Padding(padding: EdgeInsets.all(4)),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Html(data: post.excerpt, style: {
                    "*": Style(
                      fontSize: FontSize(18),
                      color: Color(0xFF666666),
                      margin: EdgeInsets.symmetric(horizontal: 0),
                    )
                  })),
            ],
            ListTile(
                title: Text(DateFormat("MMMM d").format(post.date),
                    style: TextStyle(fontSize: 18)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (post.video.length != 0 &&
                        post.video[0].trim().isNotEmpty)
                      IconButton(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => FeaturedView(post))),
                          icon: Icon(Icons.auto_awesome),
                          color: Theme.of(context).primaryColor),
                    SaveButton(post.id),
                    IconButton(
                        onPressed: () {
                          Share.share(post.link,
                              subject: "${post.title} - Central Times");
                        },
                        icon: Icon(Icons.share),
                        color: Theme.of(context).primaryColor),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  FutureBuilder<WPResponse> getFeaturedMedia(id) {
    return WordpressMediaService.getImage(id, (context, provider) {
      ValueNotifier<ImageInfo?> imgInfo = ValueNotifier(null);
      provider.resolve(ImageConfiguration())
        ..addListener(
            ImageStreamListener((ImageInfo info, _) => imgInfo.value = info));
      return ValueListenableBuilder<ImageInfo?>(
          valueListenable: imgInfo,
          builder: (context, data, child) {
            if (data != null) {
              return Ink.image(
                  image: provider,
                  width: min(data.image.width.toDouble(),
                      MediaQuery.of(context).size.width.toDouble()),
                  height: min(data.image.height.toDouble(),
                          MediaQuery.of(context).size.width.toDouble()) *
                      data.image.height.toDouble() /
                      data.image.width.toDouble(),
                  fit: BoxFit.scaleDown);
            }
            return AspectRatio(
                aspectRatio: 1.38,
                child: Center(child: CircularProgressIndicator()));
          });
      /*
      return StatefulBuilder(builder: (context, setState) {
        provider.resolve(ImageConfiguration())..addListener(ImageStreamListener((ImageInfo info, _) => setState(() => imageInfo = info)));

      });
      return FutureBuilder<ui.Image>(
        future: completer.future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Ink.image(image: provider, width: snapshot.data!.width.toDouble(), height: snapshot.data!.height.toDouble(), fit: BoxFit.scaleDown);
          }
          return CircularProgressIndicator();
        }
      );*/
    }, (context, url) {
      return AspectRatio(
          aspectRatio: 1.38, child: Center(child: CircularProgressIndicator()));
    });
  }
}
/*
 FadeInImage(
            // TODO ideally this image would have ink property
            placeholder: MemoryImage(transparentImage),
            image: provider,
            fit: BoxFit.cover,
          )*/
