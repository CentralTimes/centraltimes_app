import 'package:app/models/sections/html_model.dart';
import 'package:app/models/sections/image_model.dart';
import 'package:app/models/sections/pullquote_model.dart';
import 'package:app/models/sections/related_posts_model.dart';
import 'package:app/models/sections/section_model.dart';
import 'package:app/models/sections/unsupported_model.dart';
import 'package:app/models/sections/video_html_model.dart';
import 'package:app/models/sections/sidebar_model.dart';

import 'package:app/services/wordpress/ct_shortcode_service.dart';

class SectionLogic {
  final RegExp _intRegExp = RegExp(r"[-+]?\d+");
  final RegExp _tagRegExp = RegExp(
      r"""</?\w+((\s+\w+(\s*=\s*(?:".*?"|'.*?'|[\^'">\s]+))?)+\s*|\s*)/?>""");
  late final RegExp _shortcodeRegExp;
  late final RegExp _argumentsRegExp;

  SectionLogic() {
    /* See: https://regexr.com/667uh
     * Capturing groups:
     *  1) [ or null for whether the shortcode is double bracketed e.g. [[]]
     *  2) Shortcode name
     *  3) Shortcode arguments
     *  4) Not null if the shortcode has self-closing slash
     *  5) If shortcode is wrapping, the inner text
     *  6) ] or null for whether the shortcode is double bracketed e.g. [[]]
     */
    _shortcodeRegExp = RegExp(
        r"\[(\[?)(replace)(?![\w-])([^\]/]*(?:/(?!\])[^\]/]*)*?)(?:(/)\]|\](?:([^\[]*(?:\[(?!/\2\])[^\[]*)*)\[/\2\])?)(\]?)"
            .replaceFirst(
                "replace", CtShortcodeService.getShortcodeNames().join("|")));

    /* See: https://regexr.com/66b9m
     * Capturing groups:
     *  - EITHER Double quoted arguments e.g. width="475"
     *   1) Argument name
     *   2) Argument value
     *  - OR Single quoted arguments e.g. width='475'
     *   3) Argument name
     *   4) Argument value
     *  - OR Unquoted arguments e.g. width=475
     *   5) Argument name
     *   6) Argument value
     *  - OR Argument only
     *   7) EITHER Argument in double quotes e.g. "hidden"
     *   8) OR Argument in single quotes e.g. 'hidden'
     *   9) OR Argument e.g. hidden
     */
    _argumentsRegExp = RegExp(
        r"""([\w-]+)\s*=\s*"([^"]*)"(?:\s|$)|([\w-]+)\s*=\s*'([^']*)'(?:\s|$)|([\w-]+)\s*=\s*([^\s'"]+)(?:\s|$)|"([^"]*)"(?:\s|$)|'([^']*)'(?:\s|$)|(\S+)(?:\s|$)""");
  }

  List<_Shortcode> _parseShortcodes(String shortcodeString) {
    List<RegExpMatch> matches =
        _shortcodeRegExp.allMatches(shortcodeString).toList();
    List<_Shortcode> shortcodes = [];
    for (RegExpMatch match in matches) {
      Map<String, String> arguments = {};

      List<RegExpMatch> matches =
          _argumentsRegExp.allMatches(match.group(3) ?? "").toList();
      for (RegExpMatch match in matches) {
        if (match.group(1) != null) {
          arguments[match.group(1)!] = match.group(2) ?? "";
        } else if (match.group(3) != null) {
          arguments[match.group(3)!] = match.group(4) ?? "";
        } else if (match.group(5) != null) {
          arguments[match.group(5)!] = match.group(6) ?? "";
        } else if (match.group(7) != null) {
          arguments[match.group(7)!] = "";
        } else if (match.group(8) != null) {
          arguments[match.group(8)!] = "";
        } else if (match.group(9) != null) {
          arguments[match.group(9)!] = "";
        }
      }

      shortcodes.add(_Shortcode(
          name: match.group(2) ?? "",
          arguments: arguments,
          nested: match.group(5) ?? ""));
    }

    return shortcodes;
  }

  ///The section parser assumes that each part of the raw string separated by \r\n\r\n in ct_raw is a section.
  ///For each section, the parser identifies whether that section contains a shortcode or not, and renders
  ///the section as HTML or a shortcode section depending on the identification.

  List<SectionModel> parseSections(String rawContent) {
    List<SectionModel> sections = [];
    List<String> raws = rawContent.split("\r\n\r\n");
    for (String raw in raws) {
      if (raw.trim().isEmpty) continue;
      List<_Shortcode> shortcodes = _parseShortcodes(raw);
      if (shortcodes.isEmpty) {
        // no shortcode case: section is raw html
        sections.add(HtmlModel(html: raw));
      } else {
        // shortcode exists case: add cooresponding model to sections list
        for (_Shortcode shortcode in shortcodes) {
          switch (shortcode.name) {
            case 'video':
              sections.add(VideoHtmlModel(
                  html: shortcode.nested,
                  credit: shortcode.arguments["credit"] ?? ""));
              break;
            case 'caption':
              sections.add(ImageModel(
                  id: int.parse(_intRegExp
                          .firstMatch(shortcode.arguments["id"] ?? '0')!
                          .group(0) ??
                      '0'),
                  caption: shortcode.nested.replaceAll(_tagRegExp, '').trim()));
              break;
            case 'pullquote':
              sections.add(PullquoteModel(
                  quote: shortcode.nested,
                  speaker: shortcode.arguments["speaker"]));
              break;
            case 'related':
              List<String> storyIdsSplit =
                  (shortcode.arguments["stories"] ?? "").split(",");
              storyIdsSplit.remove("");
              sections.add(RelatedPostsModel(
                  storyIds: storyIdsSplit.map((e) => int.parse(e)).toList(),
                  title: shortcode.arguments["title"] ?? ""));
              break;
            case 'ngg':
              break;
            case 'gallery':
              break;
            case 'sidebar':
              sections.add(SidebarModel(
                  name: shortcode.nested,
                  rating: shortcode.arguments["rating"],
                  time: shortcode.arguments["time"],
                  where: shortcode.arguments["where"]));
              break;

            default:
              sections.add(UnsupportedModel(text: shortcode.toString()));
          }
        }
      }
    }
    return sections;
  }
}

class _Shortcode {
  final String name;
  final Map<String, String> arguments;
  final String nested;

  const _Shortcode(
      {required this.name, required this.arguments, required this.nested});

  @override
  String toString() {
    return 'Shortcode{name: $name, arguments: $arguments, nested: $nested}';
  }
}
