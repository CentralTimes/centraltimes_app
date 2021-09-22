import 'package:app/models/post_model.dart';
import 'package:app/services/wordpress/wordpress_media_service.dart';
import 'package:app/ui/media_loading_indicator.dart';
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
          IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_add_outlined)),
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
            Html(
                data: post.content,
                onLinkTap: (String? url, RenderContext context,
                    Map<String, String> attributes, element) async {
                  await canLaunch(url!) ? await launch(url!) : throw 'Could not launch $url';
                }),
          ])),
        ],
      ),
    );
  }

  FutureBuilder<WPResponse> getFeaturedMedia(id) {
    return WordpressMediaService.getImage(id, (context, provider) {
      return Image(image: provider, fit: BoxFit.fitWidth);
    }, (context, url) {
      return new MediaLoadingIndicator();
    });
  }
}
