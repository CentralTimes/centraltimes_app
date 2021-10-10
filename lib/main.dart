import 'package:app/models/tab_category_model.dart';
import 'package:app/services/ct/ct_ngg_gallery_service.dart';
import 'package:app/services/ct/ct_shortcode_service.dart';
import 'package:app/services/ct/ct_tab_category_service.dart';
import 'package:app/services/saved_posts_service.dart';
import 'package:app/services/section/parser/shortcode_parser_service.dart';
import 'package:app/services/wordpress/wordpress_media_service.dart';
import 'package:app/services/wordpress/wordpress_posts_service.dart';
import 'package:app/services/wordpress/wordpress_search_service.dart';
import 'package:app/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:google_fonts/google_fonts.dart';

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
  WordpressMediaService.init(api);
  WordpressSearchService.init(api);
  CtNggGalleryService.init(api);
  CtTabCategoryService.init(api);
  CtShortcodeService.init(api);
  ShortcodeParserService.init(
      await CtShortcodeService.getShortcodeNames());

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
    return MultiProvider(
      providers: [
        FutureProvider<List<TabCategoryModel>>.value(value: CtTabCategoryService.getTabCategories(), initialData: List.empty()),
      ],
      child: MaterialApp(
        title: 'Central Times',
        theme: ThemeData(
          primarySwatch: Colors.red,
          textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        ),
        home: HomeView(),
      ),
    );
  }
}
