import 'package:app/models/app_user.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/shared_prefs_service.dart';
import 'package:app/views/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AuthService.initialize();
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
    return MultiProvider(
      providers: [
        StreamProvider<AppUser?>.value(
            value: AuthService.onUserChanged, initialData: null),
      ],
      child: MaterialApp(
        title: 'Central Times',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: HomeView(),
      ),
    );
  }
}

/*
class CentralTimesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<AppUser?>.value(
            value: AuthService.onUserChanged, initialData: null),
        FutureProvider<ValueNotifier<SharedPreferences?>>(create: (context) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          return ValueNotifier(prefs);
        }, initialData: ValueNotifier(null)),
      ],
      child: MaterialApp(
        title: 'Central Times',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: HomeView(),
      ),
    );
  }
}*/
