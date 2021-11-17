import 'package:app/services/section/parser/shortcode_parser_service.dart';
import 'package:app/services/section/sections/caption_section.dart';
import 'package:app/services/section/sections/gallery_section.dart';
import 'package:app/services/section/sections/pullquote_section.dart';
import 'package:app/services/section/sections/related_section.dart';
import 'package:app/services/section/sections/unsupported_section.dart';
import 'package:app/services/section/sections/video_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class SectionParserService {
  static List<Widget> parseSections(String raw) {
    List<Widget> sections = [];

    List<Shortcode> shortcodes = ShortcodeParserService.parseShortcodes(raw);
    int position = 0;
    for (Shortcode shortcode in shortcodes) {
      sections.addAll(_generateParagraphs(
          raw.substring(position, shortcode.sourceStartIndex)));
      sections.add(_applyShortcode(shortcode));
      position = shortcode.sourceEndIndex;
    }
    sections.addAll(_generateParagraphs(raw.substring(position, raw.length)));

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
      case 'ngg':
      case 'gallery':
        return GallerySection().useShortcode(shortcode);
      default:
        return UnsupportedSection().useShortcode(shortcode);
    }
  }

  static List<Widget> _generateParagraphs(String sourceHtml) {
    List<Widget> paragraphs = [];
    List<String> paragraphHtmls = sourceHtml.trim().split("\r\n\r\n");

    for (String paragraphHtml in paragraphHtmls) {
      if (paragraphHtml.trim().isEmpty) continue;
      paragraphs.add(_generateParagraph(paragraphHtml));
    }

    return paragraphs;
  }

  static Widget _generateParagraph(String htmlData) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Html(
          data: htmlData,
          onLinkTap: (String? url, RenderContext context,
              Map<String, String> attributes, element) async {
            await launch(url!);
          },
          style: {
            "*": Style(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              fontSize: const FontSize(18),
              lineHeight: const LineHeight(1.5),
            )
          },
        ));
  }
}
