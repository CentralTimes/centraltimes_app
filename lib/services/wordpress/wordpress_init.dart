import 'package:app/services/section/parser/shortcode_parser_service.dart';
import 'package:app/services/wordpress/ct_rules_service.dart';
import 'package:app/services/wordpress/ct_shortcode_service.dart';
import 'package:wordpress_api/wordpress_api.dart';

final WordPressAPI wpApi = WordPressAPI(const String.fromEnvironment('API_BASE',
    defaultValue: 'www.centraltimes.org'));

Future<void> setupWordpress() async {
  await CtRulesService.getRules();
  ShortcodeParserService.init(await CtShortcodeService.getShortcodeNames());
}
