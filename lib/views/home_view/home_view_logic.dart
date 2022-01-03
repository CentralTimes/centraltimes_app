import 'package:app/models/tab_category_model.dart';
import 'package:app/services/wordpress/ct_tab_category_service.dart';
import 'package:flutter/material.dart';

class HomeViewLogic {
  final ValueNotifier<bool> postsPageInitializedNotifier =
      ValueNotifier<bool>(false);
  List<TabCategoryModel> tabCategories = [];
  TabController? tabController;
  void initPostsPage(TickerProvider vsync) {
    CtTabCategoryService.getTabCategories().then((value) {
      tabCategories = value;
      tabController =
          TabController(vsync: vsync, length: tabCategories.length + 1);
      postsPageInitializedNotifier.value = true;
    });
  }

  void resetPostsPage() {
    postsPageInitializedNotifier.value = false;
    tabController!.dispose();
    tabController = null;
    tabCategories = [];
  }
}
