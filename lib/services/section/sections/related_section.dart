import 'package:app/models/post_model.dart';
import 'package:app/services/section/article_section.dart';
import 'package:app/services/section/parser/shortcode_parser_service.dart';
import 'package:app/services/wordpress/wordpress_posts_service.dart';
import 'package:app/ui/list/post_list/post_preview_card.dart';
import 'package:app/ui/media_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class RelatedSection implements ArticleSection {
  @override
  Widget useShortcode(Shortcode shortcode) {
    assert(shortcode.name == 'related');

    List<String> storyIdsSplit =
        (shortcode.arguments["stories"] ?? "").split(",");
    storyIdsSplit.remove("");
    List<int> storyIds = storyIdsSplit.map((e) => int.parse(e)).toList();

    List<Widget> stories = storyIds
        .map((e) => FutureBuilder<PostModel>(
            future: WordpressPostService.getPost(e),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  !snapshot.hasError)
                return PostPreviewCard(post: snapshot.data!);
              else
                return MediaLoadingIndicator();
            }))
        .toList();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(shortcode.arguments["title"] ?? ""),
          Column(
            children: stories,
          )
        ],
      ),
    );
  }
}
