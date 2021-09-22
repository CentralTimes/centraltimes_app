import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static ValueNotifier<SharedPreferences?> prefsNotifier = ValueNotifier(null);

  static void initialize() {
    SharedPreferences.getInstance().then((prefs) {
      prefsNotifier.value = prefs;
    });
  }
}
