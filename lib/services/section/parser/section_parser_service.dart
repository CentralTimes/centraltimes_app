import 'dart:convert';

import 'package:app/services/section/parser/shortcode_parser_service.dart';
import 'package:app/services/section/sections/caption_section.dart';
import 'package:app/services/section/sections/pullquote_section.dart';
import 'package:app/services/section/sections/related_section.dart';
import 'package:app/services/section/sections/unsupported_section.dart';
import 'package:app/services/section/sections/video_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class SectionParserService {
  /*
   * The section parses assumes that each newline in ct_raw is a new section,
   * identifies whether that section contains a shortcode or not, and renders
   * the section as HTML or a shortcode section depending on the identification.
   */

  static List<Widget> parseSections(String rawContent) {
    List<Widget> sections = [];
    List<String> raws = rawContent.split("\r\n\r\n");
    for (String raw in raws) {
      if (raw.trim().isEmpty) continue;
      List<Shortcode> shortcodes = ShortcodeParserService.parseShortcodes(raw);
      if (shortcodes.isEmpty)
        sections.add(Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Html(
              data: raw,
              onLinkTap: (String? url, RenderContext context,
                  Map<String, String> attributes, element) async {
                await launch(url!);
              },
              style: {
                "*": Style(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  fontSize: FontSize(20),
                  lineHeight: LineHeight(1.0),
                )
              },
            )));
      else
        for (Shortcode shortcode in shortcodes)
          sections.add(_applyShortcode(shortcode));
    }
    return sections;
  }

  static Widget _applyShortcode(Shortcode shortcode) {
    switch (shortcode.name) {
      case 'video':
        return VideoSection().useShortcode(shortcode);
      case 'caption':
        return CaptionSection().useShortcode(shortcode);
      case 'pullquote':
        return PullquoteSection().useShortcode(shortcode);
      case 'related':
        return RelatedSection().useShortcode(shortcode);
      default:
        return UnsupportedSection().useShortcode(shortcode);
    }
  }
}
