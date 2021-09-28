import 'package:app/services/ct/ct_shortcode_service.dart';
import 'package:app/services/saved_posts_service.dart';
import 'package:app/services/section/parser/shortcode_parser_service.dart';
import 'package:app/services/wordpress/wordpress_media_service.dart';
import 'package:app/services/wordpress/wordpress_posts_service.dart';
import 'package:app/services/wordpress/wordpress_search_service.dart';
import 'package:app/services/wordpress/wordpress_staff_name_service.dart';
import 'package:app/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

void main() async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    print(
        '[${record.level.name}]-${record.loggerName}: ${record.time}: ${record.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();

  await SavedPostsService.init();

  final api = WordPressAPI('www.centraltimes.org');
  WordpressPostService.init(api);
  WordpressStaffNameService.init(api);
  WordpressMediaService.init(api);
  WordpressSearchService.init(api);
  WordpressShortcodeService.init(api);
  ShortcodeParserService.init(
      await WordpressShortcodeService.getShortcodeNames());

  runApp(CentralTimesApp());
}

class CentralTimesApp extends StatefulWidget {
  @override
  _CentralTimesAppState createState() => _CentralTimesAppState();
}

class _CentralTimesAppState extends State<CentralTimesApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Central Times',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomeView(),
    );
  }
}
