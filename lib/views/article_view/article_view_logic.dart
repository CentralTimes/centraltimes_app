import 'package:app/logic/media_logic.dart';
import 'package:app/services/logic_getit_init.dart';
import 'package:flutter/material.dart';

class ArticleViewLogic {
  final viewInitializedNotifier = ValueNotifier<bool>(false);

  void initView() {
    viewInitializedNotifier.value = true;
  }

  void dispose() {
    viewInitializedNotifier.value = false;
  }
}
