import 'package:app/services/section/parser/shortcode_parser_service.dart';
import 'package:app/services/wordpress/ct_shortcode_service.dart';

class ShortcodeLogic {
  late final RegExp _shortcodeRegExp;
  late final RegExp _argumentsRegExp;
  ShortcodeLogic() {
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
}
