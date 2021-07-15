import 'package:app/models/app_user.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/views/sign-in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AuthService.initialize();
  runApp(CentralTimesApp());
}

class CentralTimesApp extends StatelessWidget {
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
        home: SignInView(),
      ),
    );
  }
}
