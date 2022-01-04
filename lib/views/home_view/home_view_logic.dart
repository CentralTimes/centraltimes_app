import 'dart:math';

import 'package:app/logic/media_logic.dart';
import 'package:app/logic/posts_logic.dart';
import 'package:app/models/post_model.dart';
import 'package:app/models/tab_category_model.dart';
import 'package:app/services/logic_getit_init.dart';
import 'package:app/services/saved_posts_service.dart';
import 'package:app/services/wordpress/ct_tab_category_service.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logging/logging.dart';

class HomeViewLogic {
  final ValueNotifier<bool> postsPageInitializedNotifier =
      ValueNotifier<bool>(false);
  List<TabCategoryModel> tabCategories = [];
  List<PagingController<int, PostModel>> pagingControllers = [];
  TabController? tabController;
  final ValueNotifier<bool> savedPageInitializedNotifier =
      ValueNotifier<bool>(false);
  PagingController<int, PostModel>? savedPagingController;
  final Logger log = Logger("HomeViewLogic");
  final int _postsPerPage = 10;
  void initPostsPage(TickerProvider vsync) {
    CtTabCategoryService.getTabCategories().then((value) {
      tabCategories = value;
      tabController =
          TabController(vsync: vsync, length: tabCategories.length + 1);
      pagingControllers = List.generate(tabCategories.length + 1, (index) {
        PagingController<int, PostModel> controller =
            PagingController(firstPageKey: 1);
        controller.addPageRequestListener((pageKey) {
          _fetchPage(controller: controller, tabIndex: index, pageKey: pageKey);
        });
        return controller;
      });
      postsPageInitializedNotifier.value = true;
    });
  }

  Future<void> _fetchPage(
      {required PagingController<int, PostModel> controller,
      required int tabIndex,
      required int pageKey}) async {
    PostsLogic postsLogic = getIt<PostsLogic>();
    MediaLogic mediaLogic = getIt<MediaLogic>();
    try {
      final List<PostModel> newItems = await postsLogic.getPageOfPosts(
          pageId: pageKey,
          postsPerPage: _postsPerPage,
          categoryId: tabIndex == 0 ? null : tabCategories[tabIndex - 1].id);
      //log.info(tabCategories);
      List<int> mediaIds = [];
      for (PostModel item in newItems) {
        if (item.featuredMedia != 0) mediaIds.add(item.featuredMedia);
      }
      await mediaLogic.getMedia(mediaIds);
      if (newItems.length < _postsPerPage) {
        controller.appendLastPage(newItems);
      } else {
        controller.appendPage(newItems, pageKey + 1);
      }
    } catch (e) {
      controller.error = e;
    }
  }

  void resetPostsPage() {
    postsPageInitializedNotifier.value = false;
    tabController!.dispose();
    tabController = null;
    for (PagingController<int, PostModel> controller in pagingControllers) {
      controller.dispose();
    }
    pagingControllers = [];
    tabCategories = [];
  }

  void initSavedPage() {
    savedPagingController = PagingController(firstPageKey: 0);
    savedPagingController!.addPageRequestListener((pageKey) {
      _fetchSaved(savedPagingController!, pageKey);
    });
    savedPageInitializedNotifier.value = true;
  }

  Future<void> _fetchSaved(
      PagingController<int, PostModel> controller, int pageKey) async {
    PostsLogic postsLogic = getIt<PostsLogic>();
    MediaLogic mediaLogic = getIt<MediaLogic>();
    List<int> allPostIds = SavedPostsService.getPosts();
    List<PostModel> newItems = await postsLogic.getPosts(
        postIds: SavedPostsService.getPosts()
            .sublist(pageKey, min(pageKey + _postsPerPage, allPostIds.length)));
    List<int> mediaIds = [];
    for (PostModel item in newItems) {
      if (item.featuredMedia != 0) mediaIds.add(item.featuredMedia);
    }
    await mediaLogic.getMedia(mediaIds);
    if (newItems.length < _postsPerPage) {
      controller.appendLastPage(newItems);
    } else {
      controller.appendPage(newItems, pageKey + _postsPerPage);
    }
  }

  void resetSavedPage() {
    savedPagingController!.dispose();
    savedPagingController = null;
    savedPageInitializedNotifier.value = false;
  }
}
