class ShortcodeParserService {
  static RegExp? shortcodeRegExp;
  static RegExp? argumentsRegExp;

  static init(List<String> shortcodeStrings) {
    shortcodeRegExp = _createShortcodeRegExp(shortcodeStrings);
    argumentsRegExp = _createArgumentsRegExp();
  }

  static bool containsShortcode(String shortcodeString) {
    return shortcodeRegExp!.hasMatch(shortcodeString);
  }

  static List<Shortcode> parseShortcodes(String shortcodeString) {
    List<RegExpMatch> matches =
        shortcodeRegExp!.allMatches(shortcodeString).toList();
    List<Shortcode> shortcodes = [];

    for (RegExpMatch match in matches) {
      String name = match.group(2) ?? "";
      Map<String, String> arguments = parseArguments(match.group(3) ?? "");
      String nested = match.group(5) ?? "";

      shortcodes.add(Shortcode(name, arguments, nested));
    }

    return shortcodes;
  }

  static Map<String, String> parseArguments(String argsString) {
    Map<String, String> arguments = {};

    List<RegExpMatch> matches =
        argumentsRegExp!.allMatches(argsString).toList();
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

    return arguments;
  }

  static RegExp _createShortcodeRegExp(List<String> shortcodeStrings) {
    /* See: https://regexr.com/667uh
     * Capturing groups:
     *  1) [ or null for whether the shortcode is double bracketed e.g. [[]]
     *  2) Shortcode name
     *  3) Shortcode arguments
     *  4) Not null if the shortcode has self-closing slash
     *  5) If shortcode is wrapping, the inner text
     *  6) ] or null for whether the shortcode is double bracketed e.g. [[]]
     */
    return RegExp(
        r"\[(\[?)(replace)(?![\w-])([^\]/]*(?:/(?!\])[^\]/]*)*?)(?:(/)\]|\](?:([^\[]*(?:\[(?!/\2\])[^\[]*)*)\[/\2\])?)(\]?)"
            .replaceFirst("replace", shortcodeStrings.join("|")));
  }

  static RegExp _createArgumentsRegExp() {
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
    return RegExp(
        r"""([\w-]+)\s*=\s*"([^"]*)"(?:\s|$)|([\w-]+)\s*=\s*'([^']*)'(?:\s|$)|([\w-]+)\s*=\s*([^\s'"]+)(?:\s|$)|"([^"]*)"(?:\s|$)|'([^']*)'(?:\s|$)|(\S+)(?:\s|$)""");
  }
}

class Shortcode {
  final String name;
  final Map<String, String> arguments;
  final String nested;

  Shortcode(this.name, this.arguments, this.nested);

  @override
  String toString() {
    return 'Shortcode{name: $name, arguments: $arguments, nested: $nested}';
  }
}
