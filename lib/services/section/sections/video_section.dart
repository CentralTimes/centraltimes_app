import 'package:app/services/section/article_section.dart';
import 'package:app/services/section/parser/shortcode_parser_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class VideoSection extends ArticleSection {
  // Currently a simple wrapper that only handles Youtube embed well.
  // TODO follow sno_video_shortcode function's flow to replicate behavior

  @override
  Widget useShortcode(Shortcode shortcode) {
    assert(shortcode.name == 'video');
    return Column(
      children: [
        Html(
          data: shortcode.nested,
          style: {
            "*": Style(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
            )
          },
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(shortcode.arguments["credit"] ?? ""))
      ],
    );
  }
}
