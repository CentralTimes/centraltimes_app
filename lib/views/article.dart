import 'package:app/models/post_model.dart';
import 'package:app/services/wordpress/wordpress_media_service.dart';
import 'package:app/ui/media_loading_indicator.dart';
import 'package:app/ui/transparent_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wordpress_api/wordpress_api.dart';

class ArticleView extends StatelessWidget {
  final PostModel post;

  const ArticleView({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Central Times"),
        actions: [
          IconButton(
              onPressed: () {
                Share.share(post.link,
                    subject: "${post.title} - Central Times");
              },
              icon: Icon(Icons.share)),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate.fixed([
            Padding(padding: EdgeInsets.all(8)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(post.title,
                    style: TextStyle(fontSize: 28, height: 1.5))),
            Padding(padding: EdgeInsets.all(8)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                    DateFormat("MMMM d, yyyy - h:mm a").format(post.date),
                    style: TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        color: Colors.black.withOpacity(0.6)))),
            Padding(padding: EdgeInsets.all(8)),
            if (post.featuredMedia != 0) getFeaturedMedia(post.featuredMedia),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Html(
                  data: post.content,
                  onLinkTap: (String? url, RenderContext context,
                      Map<String, String> attributes, element) async {
                    await launch(url!);
                  },
                  style: {
                    "*": Style(
                      margin: EdgeInsets.symmetric(horizontal: 0),
                    ),
                    "p": Style(
                      fontSize: FontSize(20),
                      lineHeight: LineHeight(1.0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    // Temporary figure styles...
                    ".videowidget": Style(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      // TODO somehow add text padding (wait for preprocessor?)
                    ),
                    "figure": Style(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    ".wp-caption-text": Style(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    // Don't support galleries
                    ".back": Style(
                      display: Display.NONE,
                    ),
                    ".next": Style(
                      display: Display.NONE,
                    ),
                    ".counter": Style(
                      display: Display.NONE,
                    ),
                  },
                )),
          ])),
        ],
      ),
    );
  }

  FutureBuilder<WPResponse> getFeaturedMedia(id) {
    return WordpressMediaService.getImage(id, (context, provider) {
      return FadeInImage(
          placeholder: MemoryImage(transparentImage),
          image: provider,
          fit: BoxFit.fitWidth);
    }, (context, url) {
      return new MediaLoadingIndicator();
    });
  }
}
