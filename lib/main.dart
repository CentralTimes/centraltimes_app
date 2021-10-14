import 'package:app/services/ct/ct_ngg_gallery_service.dart';
import 'package:app/services/ct/ct_shortcode_service.dart';
import 'package:app/services/ct/ct_sno_gallery_service.dart';
import 'package:app/services/ct/ct_tab_category_service.dart';
import 'package:app/services/saved_posts_service.dart';
import 'package:app/services/section/parser/shortcode_parser_service.dart';
import 'package:app/services/wordpress/wordpress_media_service.dart';
import 'package:app/services/wordpress/wordpress_posts_service.dart';
import 'package:app/services/wordpress/wordpress_search_service.dart';
import 'package:app/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

void main() async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    debugPrint(
        '[${record.level.name}]-${record.loggerName}: ${record.time}: ${record.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();

  const firebaseKey = String.fromEnvironment('FIREBASE_KEY', defaultValue: '');
  assert(firebaseKey != '');
  const apiBase =
      String.fromEnvironment('API_BASE', defaultValue: 'www.centraltimes.org');

  await SavedPostsService.init();

  final api = WordPressAPI(apiBase);
  WordpressPostService.init(api);
  WordpressMediaService.init(api);
  WordpressSearchService.init(api);
  CtNggGalleryService.init(api);
  CtSnoGalleryService.init(api);
  CtTabCategoryService.init(api);
  CtShortcodeService.init(api);
  ShortcodeParserService.init(await CtShortcodeService.getShortcodeNames());

  runApp(const CentralTimesApp());
}

class CentralTimesApp extends StatefulWidget {
  const CentralTimesApp({Key? key}) : super(key: key);

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
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
      ),
      home: const HomeView(),
    );
  }
}
