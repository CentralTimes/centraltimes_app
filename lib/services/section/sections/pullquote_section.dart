import 'package:app/services/section/article_section.dart';
import 'package:app/services/section/parser/shortcode_parser_service.dart';
import 'package:app/services/wordpress/wordpress_media_service.dart';
import 'package:app/ui/transparent_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class PullquoteSection implements ArticleSection {
  RegExp intRegExp = new RegExp(r"[-+]?\d+");

  @override
  Widget useShortcode(Shortcode shortcode) {
    assert(shortcode.name == 'pullquote');
    // TODO make prettier
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        child: Column(
          children: [
            if (intRegExp.hasMatch(shortcode.arguments["photo"] ?? ""))
              WordpressMediaService.getImage(
                  int.parse(shortcode.arguments["photo"] ?? ""),
                  (context, provider) {
                return FadeInImage(
                    placeholder: MemoryImage(transparentImage),
                    image: provider,
                    fit: BoxFit.fitWidth);
              }, (context, url) {
                return AspectRatio(aspectRatio: 1.38);
              }),
            Text('"${shortcode.nested}"', style: TextStyle(fontStyle: FontStyle.italic),),
            Text("--${shortcode.arguments["speaker"] ?? ""}")
          ],
        ));
  }
}
