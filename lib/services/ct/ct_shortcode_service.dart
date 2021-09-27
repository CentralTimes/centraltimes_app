import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class WordpressShortcodeService {
  static WordPressAPI? api;
  static final Logger log = new Logger("WordpressShortcodeService");

  static void init(WordPressAPI api) {
    WordpressShortcodeService.api = api;
    log.info("Initialized!");
  }

  static Future<List<String>> getShortcodeNames() async {
    final WPResponse res = await WordpressShortcodeService.api!.fetch(
        'shortcodes', namespace: 'centraltimes/v1');
    return res.data.keys.toList();
  }
}