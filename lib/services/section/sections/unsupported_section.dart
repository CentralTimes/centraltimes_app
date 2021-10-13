import 'package:app/services/section/article_section.dart';
import 'package:app/services/section/parser/shortcode_parser_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class UnsupportedSection implements ArticleSection {
  @override
  Widget useShortcode(Shortcode shortcode) {
    return Text("Unsupported Shortcode: ${shortcode.toString()}");
  }
}
