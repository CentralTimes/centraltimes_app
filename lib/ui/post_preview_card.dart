import 'dart:math';

import 'package:app/models/post_model.dart';
import 'package:app/services/shared_prefs_service.dart';
import 'package:app/views/article.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class PostPreviewCard extends StatelessWidget {
  final PostModel post;
  static const double blur = 1;
  PostPreviewCard({ required this.post });
  @override
  Widget build(BuildContext context) {
    return InkWell(
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
            Padding(padding: EdgeInsets.all(8)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(post.title,
                    style: TextStyle(fontSize: 28))),
            ListTile(
                title: Text(
                    DateFormat("MMMM d").format(post.date),
                    style: TextStyle(fontSize: 18)),
                ),
          ],
        ),
      ),
    );
  }

  Widget? getHeadMedia(List<Map<String, dynamic>> sections) {
    if (sections.isEmpty || sections[0]["url"] == null) return null;
    return CachedNetworkImage(
        imageUrl: sections[0]["url"],
        imageBuilder: (context, provider) {
          return Ink.image(
              image: provider,
              fit: BoxFit.contain,
              width: min(sections[0]["width"].toDouble(),
                  MediaQuery.of(context).size.width.toDouble()),
              height: min((sections[0]["width"] as num).toDouble(),
                      MediaQuery.of(context).size.width.toDouble()) *
                  sections[0]["height"].toDouble() /
                  sections[0]["width"].toDouble());
        },
        placeholder: (context, url) => Container(
              width: min(sections[0]["width"].toDouble(),
                  MediaQuery.of(context).size.width.toDouble()),
              height: min((sections[0]["width"] as num).toDouble(),
                      MediaQuery.of(context).size.width.toDouble()) *
                  sections[0]["height"].toDouble() /
                  sections[0]["width"].toDouble(),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ));
  }
}
