import 'package:app/models/post_model.dart';
import 'package:app/services/section/parser/section_parser_service.dart';
import 'package:app/services/wordpress/wordpress_media_service.dart';
import 'package:app/ui/save_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wordpress_api/wordpress_api.dart';

import 'featured_view.dart';

class ArticleView extends StatelessWidget {
  final PostModel post;
  final _scrollController = ScrollController();

  ArticleView(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Central Times"),
        actions: [
          SaveButton(
            post.id,
            iconColor: Colors.white,
          ),
          IconButton(
              onPressed: () {
                Share.share(post.link,
                    subject: "${post.title} - Central Times");
              },
              icon: const Icon(Icons.share)),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate.fixed([
            const Padding(padding: EdgeInsets.all(8)),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(post.title,
                    style: const TextStyle(fontSize: 28, height: 1.5))),
            if (post.staffNames.isNotEmpty) ...[
              const Padding(padding: EdgeInsets.all(4)),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    post.writers.join(", "),
                    style: const TextStyle(fontSize: 18),
                  )),
            ],
            const Padding(padding: EdgeInsets.all(4)),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                    DateFormat("MMMM d, yyyy - h:mm a").format(post.date),
                    style: TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        color: Colors.black.withOpacity(0.6)))),
            const Padding(padding: EdgeInsets.all(8)),
            if (post.featuredMedia != 0) getFeaturedMedia(post.featuredMedia),
            if (post.video.isNotEmpty && post.video[0].trim().isNotEmpty)
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => FeaturedView(post))),
                child: Row(children: const [
                  Icon(Icons.auto_awesome),
                  Text("View Featured Content")
                ]),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                  children:
                      SectionParserService.parseSections(post.rawContent)),
            ),
          ])),
        ],
      ),
    );
  }

  FutureBuilder<WPResponse> getFeaturedMedia(id) {
    return WordpressMediaService.getImage(id, (context, provider) {
      return Image(image: provider);
    }, (context, url) {
      return const AspectRatio(
          aspectRatio: 1.38, child: Center(child: CircularProgressIndicator()));
    });
  }
}
