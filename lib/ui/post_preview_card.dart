import 'dart:math';

import 'package:app/models/post_model.dart';
import 'package:app/services/shared_prefs_service.dart';
import 'package:app/services/wordpress/wordpress_media_service.dart';
import 'package:app/views/article.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wordpress_api/src/helpers.dart';

class PostPreviewCard extends StatelessWidget {
  final PostModel post;
  static const double blur = 1;

  PostPreviewCard({required this.post}) : super();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: InkWell(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ArticleView(post: post))),
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
            Center(
              child: getHeadMedia(post.featuredMedia),
            ),
            Padding(padding: EdgeInsets.all(8)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(post.title, style: TextStyle(fontSize: 28))),
            if (post.excerpt != null && post.excerpt != "") ...[
              Padding(padding: EdgeInsets.all(4)),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Html(data: post.excerpt, style: {
                    "*": Style(
                      fontSize: FontSize(18),
                      color: Color(0xFF666666),
                    )
                  })),
            ],
            ListTile(
              title: Text(DateFormat("MMMM d").format(post.date),
                  style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    ));
  }

  FutureBuilder<WPResponse> getHeadMedia(id) {
    return WordpressMediaService.getImage(id, (context, provider) {
      return Ink.image(image: provider, fit: BoxFit.contain, width: 500, height: 300,);
    }, (context, url) {
      return Container(
          child: Center(
        child: CircularProgressIndicator(),
      ));
    });
  }
}
