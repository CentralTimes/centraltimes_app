import 'package:app/services/ct/ct_ngg_gallery_service.dart';
import 'package:app/services/ct/ct_rules_service.dart';
import 'package:app/services/ct/ct_shortcode_service.dart';
import 'package:app/services/ct/ct_sno_gallery_service.dart';
import 'package:app/services/ct/ct_tab_category_service.dart';
import 'package:app/services/saved_posts_service.dart';
import 'package:app/services/section/parser/shortcode_parser_service.dart';
import 'package:app/services/wordpress/wordpress_media_service.dart';
import 'package:app/services/wordpress/wordpress_posts_service.dart';
import 'package:app/services/wordpress/wordpress_search_service.dart';
import 'package:app/views/home_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

void main() async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    debugPrint(
        '[${record.level.name}]-${record.loggerName}: ${record.time}: ${record.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();

  const apiBase =
      String.fromEnvironment('API_BASE', defaultValue: 'www.centraltimes.org');

  await SavedPostsService.init();

  await Firebase.initializeApp();
  final api = WordPressAPI(apiBase);

  CtRulesService.init(api);
  await CtRulesService.getRules();
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
    initDynamicLinks();
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;
      if (deepLink != null) {
        switch (deepLink.path) {
          case 'android':
            break;
          case 'ios':
            break;
          default:
        }
      }
    }, onError: (OnLinkErrorException e) async {
      debugPrint('onLinkError');
      debugPrint(e.message);
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      switch (deepLink.path) {
        case 'android':
          break;
        case 'ios':
          break;
        default:
      }
    }
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
