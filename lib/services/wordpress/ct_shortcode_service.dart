import 'package:app/services/wordpress/wordpress_init.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class CtShortcodeService {
  static final Logger log = Logger("CtShortcodeService");

  static Future<List<String>> getShortcodeNames() async {
    final WPResponse res =
        await wpApi.fetch('shortcodes', namespace: 'centraltimes/v1');
    return (res.data as List).map((e) => e.toString()).toList();
  }
}
