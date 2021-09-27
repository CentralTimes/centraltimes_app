import 'package:app/services/section/article_section.dart';
import 'package:app/services/section/parser/shortcode_parser_service.dart';
import 'package:app/services/wordpress/wordpress_media_service.dart';
import 'package:app/ui/transparent_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

class CaptionSection implements ArticleSection {
  RegExp intRegExp = new RegExp(r"[-+]?\d+");
  RegExp tagRegExp = new RegExp(
      r"""</?\w+((\s+\w+(\s*=\s*(?:".*?"|'.*?'|[\^'">\s]+))?)+\s*|\s*)/?>""");

  @override
  Widget useShortcode(Shortcode shortcode) {
    assert(shortcode.name == 'caption');

    int mediaId = int.parse(
        intRegExp.firstMatch(shortcode.arguments["id"] ?? '0')!.group(0) ??
            '0');
    String caption = shortcode.nested.replaceAll(tagRegExp, '').trim();

    return Column(
      children: [
        WordpressMediaService.getImage(mediaId, (context, provider) {
          return FadeInImage(
              placeholder: MemoryImage(transparentImage),
              image: provider,
              fit: BoxFit.fitWidth);
        }, (context, url) {
          return AspectRatio(aspectRatio: 1.38);
        }),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(caption),
        )
      ],
    );
  }
}
