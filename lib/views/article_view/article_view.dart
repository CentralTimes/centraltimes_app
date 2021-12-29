import 'package:app/models/post_model.dart';
import 'package:app/services/section/parser/section_parser_service.dart';
import 'package:app/services/wordpress/v2/wordpress_media_service.dart';
import 'package:app/ui/custom_buttons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wordpress_api/wordpress_api.dart';

import '../featured_view.dart';

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
            ArticleTitle(title: post.title),
            if (post.staffNames.isNotEmpty) ...[
              const Padding(padding: EdgeInsets.all(4)),
              ArticleAuthors(authors: post.writers.join(", ")),
            ],
            const Padding(padding: EdgeInsets.all(4)),
            ArticleDate(date: post.date),
            const Padding(padding: EdgeInsets.all(8)),
            if (post.featuredMedia != 0)
              ArticleImageBuilder(id: post.featuredMedia),
            if (post.video.isNotEmpty && post.video[0].trim().isNotEmpty)
              ArticleFeaturedButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => FeaturedView(post)))),
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
}

class ArticleTitle extends StatelessWidget {
  final String? title;

  const ArticleTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(title ?? "",
            style: const TextStyle(fontSize: 28, height: 1.5)));
  }
}

class ArticleAuthors extends StatelessWidget {
  final String? authors;

  const ArticleAuthors({Key? key, required this.authors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          authors ?? "",
          style: const TextStyle(fontSize: 18),
        ));
  }
}

class ArticleDate extends StatelessWidget {
  final DateTime date;

  const ArticleDate({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(DateFormat("MMMM d, yyyy - h:mm a").format(date),
            style: TextStyle(
                fontSize: 18,
                height: 1.5,
                color: Colors.black.withOpacity(0.6))));
  }
}

class ArticleImageBuilder extends StatelessWidget {
  final int id;

  const ArticleImageBuilder({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return CachedNetworkImage(imageUrl: imageUrl)
    return WordpressMediaService.getImage(id, (context, provider) {
      return Image(image: provider);
    }, (context, url) {
      return const AspectRatio(
          aspectRatio: 1.38, child: Center(child: CircularProgressIndicator()));
    });
  }
}

class ArticleFeaturedButton extends StatelessWidget {
  final void Function()? onPressed;
  const ArticleFeaturedButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(children: const [
        Icon(Icons.auto_awesome),
        Text("View Featured Content")
      ]),
    );
  }
}
