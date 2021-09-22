import 'package:app/models/user_model.dart';
import 'package:app/services/shared_prefs_service.dart';
import 'package:app/services/wordpress/wordpress_media_service.dart';
import 'package:app/services/wordpress/wordpress_posts_service.dart';
import 'package:app/views/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_api/wordpress_api.dart';

void main() async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final api = WordPressAPI('www.centraltimes.org');
  WordpressPostsService.init(api);
  WordpressMediaService.init(api);

  WidgetsFlutterBinding.ensureInitialized();
  SharedPrefsService.initialize();
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
