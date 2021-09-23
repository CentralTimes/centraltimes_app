import 'package:app/models/post_model.dart';
import 'package:app/services/wordpress/wordpress_media_service.dart';
import 'package:app/views/article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wordpress_api/src/helpers.dart';

import '../transparent_image.dart';

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
    ));
  }

  FutureBuilder<WPResponse> getFeaturedMedia(id) {
    return WordpressMediaService.getImage(id, (context, provider) {
      return AspectRatio(
          aspectRatio: 1.38,
          child: FadeInImage(
            // TODO ideally this image would have ink property
            placeholder: MemoryImage(transparentImage),
            image: provider,
            fit: BoxFit.cover,
          ));
    }, (context, url) {
      return AspectRatio(aspectRatio: 1.38);
    });
  }
}
