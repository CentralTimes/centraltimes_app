import 'package:app/services/wordpress/wordpress_init.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class CtShortcodeService {
  static late final List<String> _shortcodeNamesList;
  static final Logger log = Logger("CtShortcodeService");

  static Future<void> init() async {
    final WPResponse res =
        await wpApi.fetch('shortcodes', namespace: 'centraltimes/v1');
    _shortcodeNamesList = (res.data as List).map((e) => e.toString()).toList();
  }

  static List<String> getShortcodeNames() {
    return _shortcodeNamesList;
  }
}
