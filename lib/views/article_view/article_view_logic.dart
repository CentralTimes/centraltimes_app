import 'package:app/logic/media_logic.dart';
import 'package:app/services/logic_locator.dart';
import 'package:flutter/material.dart';

class ArticleViewLogic {
  final viewInitializedNotifier = ValueNotifier<bool>(false);

  void finishInitialization() {
    viewInitializedNotifier.value = true;
  }
}
