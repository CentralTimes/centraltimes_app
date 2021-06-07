import 'package:app/views/home.dart';
import 'package:app/views/sign-in.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Central Times',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SignInView(),
    );
  }
}
