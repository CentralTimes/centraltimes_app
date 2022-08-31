import 'package:app/services/logic_getit_init.dart';
import 'package:app/services/wordpress/wordpress_init.dart';
import 'package:app/views/home_view/home_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app/services/saved_posts_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

void main() async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    debugPrint(
        '[${record.level.name}]-${record.loggerName}: ${record.time}: ${record.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();

  await SavedPostsService.init();

  await Firebase.initializeApp();

  await setupWordpress();

  setupGetIt();

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
        colorScheme: const ColorScheme(
          primary: Color.fromRGBO(239, 72, 68, 1),
          secondary: Color.fromRGBO(239, 72, 68, 1),
          surface: Colors.white,
          background: Colors.white,
          error: Colors.black,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
      ),
      home: const HomeView(),
    );
  }
}
