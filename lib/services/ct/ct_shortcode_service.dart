import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class CtShortcodeService {
  static late WordPressAPI api;
  static final Logger log = new Logger("CtShortcodeService");

  static void init(WordPressAPI api) {
    CtShortcodeService.api = api;
    log.info("Initialized!");
  }

  static Future<List<String>> getShortcodeNames() async {
    final WPResponse res = await CtShortcodeService.api
        .fetch('shortcodes', namespace: 'centraltimes/v1');
    return (res.data as List).map((e) => e.toString()).toList();
  }
}
