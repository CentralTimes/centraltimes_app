import 'package:app/services/section/parser/shortcode_parser_service.dart';
import 'package:flutter/material.dart';

abstract class ArticleSection {
  Widget useShortcode(Shortcode shortcode);
}