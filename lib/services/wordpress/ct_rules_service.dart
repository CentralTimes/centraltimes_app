import 'dart:io';

import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class CtRulesService {
  static late WordPressAPI api;
  static final Logger log = Logger("CtRulesService");

  static Map<String, dynamic> rules = {};

  static void init(WordPressAPI api) {
    CtRulesService.api = api;
    log.info("Initialized!");
  }

  static Future<void> getRules() async {
    final WPResponse res =
        await CtRulesService.api.fetch('rules', namespace: 'centraltimes/v1');
    rules = res.data;
  }

  static bool applyRuleList(String ruleList, Map<String, dynamic> item) {
    bool selected = true;
    for (Map<String, dynamic> rule in rules[ruleList]) {
      selected = selected &&
          _applyRule(
              item, rule["type"], rule["mode"], rule["args"], rule["comment"]);
    }
    return selected;
  }

  static bool _applyRule(Map<String, dynamic> item, String type, String mode,
      Map<String, dynamic> args, String? comment) {
    bool result = _processors[type]!(item, args);
    switch (mode) {
      case 'select':
        result = result;
        break;
      case 'unselect':
        result = !result;
        break;
      default:
        throw AssertionError(
            "mode in rule should either be select or unselect");
    }
    return result;
  }

  static final Map<String, Function> _processors = {
    "all": (Map<String, dynamic> item, Map<String, dynamic> args) {
      bool selected = true;
      for (Map<String, dynamic> rule in args["rules"]) {
        selected = selected &&
            _applyRule(item, rule["type"], rule["mode"], rule["args"],
                rule["comment"]);
      }
      return selected;
    },
    "any": (Map<String, dynamic> item, Map<String, dynamic> args) {
      bool selected = false;
      for (Map<String, dynamic> rule in args["rules"]) {
        selected = selected ||
            _applyRule(item, rule["type"], rule["mode"], rule["args"],
                rule["comment"]);
      }
      return selected;
    },
    "field": (Map<String, dynamic> item, Map<String, dynamic> args) {
      /*
      TODO ideally this implementation would be backtracking... sadly, the
       current implementation chooses to assume that there is only one "edge"
       per map "node".
       */
      Map<String, dynamic> currentItemMap = item;
      Map<String, dynamic> currentMatchMap = args["match"];

      bool matches = true;
      bool complete = false;

      while (!complete) {
        matches =
            matches && currentItemMap[currentMatchMap.keys.toList()[0]] != null;
        if (!matches) break;
        if (currentMatchMap.values.toList()[0] is Map) {
          currentItemMap = currentItemMap[currentMatchMap.keys.toList()[0]];
          currentMatchMap = currentMatchMap.values.toList()[0];
        } else {
          RegExp regexp =
              RegExp(currentMatchMap.values.toList()[0], multiLine: true);
          log.info("CREATING REGEX ${currentMatchMap.values.toList()[0]}");
          if (currentItemMap[currentMatchMap.keys.toList()[0]] is! List) {
            matches = matches &&
                regexp.hasMatch(currentItemMap[currentMatchMap.keys.toList()[0]]
                    .toString());
            break;
          } else {
            if (currentItemMap[currentMatchMap.keys.toList()[0]].length == 0) {
              matches = false;
              break;
            }
            for (dynamic entry
                in currentItemMap[currentMatchMap.keys.toList()[0]]) {
              matches = matches && regexp.hasMatch(entry.toString());
              log.info("testing ${entry.toString()}");
              if (matches) {
                log.info(
                    "${currentMatchMap.values.toList()[0]} matched ${entry.toString()}");
              }
            }
            break;
          }
        }
      }
      log.info("RESULT: $matches");
      return matches;
    },
    "platform": (Map<String, dynamic> item, Map<String, dynamic> args) {
      switch (args["platform"]) {
        case 'iOS':
          return Platform.isIOS;
        case 'Android':
          return Platform.isAndroid;
        default:
          throw AssertionError("platform in rule should be iOS or Android");
      }
    },
  };
}
