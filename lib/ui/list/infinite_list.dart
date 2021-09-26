import 'package:app/ui/list/list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logging/logging.dart';

import '../error_screens/error_screen.dart';
import '../error_screens/no_results_error_screen.dart';

class InfiniteListState<T> extends State<StatefulWidget> {
  final _pagingController = PagingController<int, T>(firstPageKey: 1);
  final _scrollController = ScrollController();
  final log = new Logger("InfiniteList");
  final scrollToTop = true;

  bool _showRefreshButton = false;
  double _lastReversal = 0.0;

  Widget buildItem(BuildContext context, T data, int index) {
    return AspectRatio(aspectRatio: 1.5, child: Placeholder());
  }

  Widget buildFirstPageErrorIndicator(BuildContext context) {
    final error = _pagingController.error.toString();
    log.severe(error);
    return RefreshIndicator(
        onRefresh: () => Future.sync(() => refresh()),
        child: ErrorScreen(title: "Application Error", message: error));
  }

  @override
  Widget build(BuildContext context) {
    if (scrollToTop)
      return ScrollWrapper(
        scrollController: _scrollController,
        child: _commonList(),
        promptAlignment: Alignment.bottomRight,
        promptReplacementBuilder: (BuildContext context, Function scrollToTop) {
          return Padding(
              padding: EdgeInsets.all(16),
              child: FloatingActionButton(
                onPressed: () {
                  scrollToTop();
                },
                child: Icon(Icons.arrow_upward),
              ));
        },
      );
    else
      return _commonList();
  }

  RefreshIndicator _commonList() {
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => refresh()),
      child: PagedListView.separated(
        pagingController: _pagingController,
        scrollController: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 0),
        builderDelegate: PagedChildBuilderDelegate<T>(
          itemBuilder: buildItem,
          firstPageErrorIndicatorBuilder: buildFirstPageErrorIndicator,
          noItemsFoundIndicatorBuilder: (context) => NoResultsErrorScreen(),
        ),
        separatorBuilder: (context, index) => Divider(
          height: 2,
          color: Colors.grey,
          thickness: 2,
        ),
      ),
    );
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _processPage(pageKey);
    });
    super.initState();
  }

  Future<void> _processPage(int pageKey) async {
    try {
      final newPage = await fetchPage(pageKey);
      // Final page to load if length < 10
      if (newPage.isLast) {
        _pagingController.appendLastPage(newPage.items);
      } else {
        _pagingController.appendPage(newPage.items, pageKey + 1);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  Future<ListPage<T>> fetchPage(int pageKey) async {
    return ListPage(List.empty(), true);
  }

  @override
  void dispose() {
    log.info("Disposed!");
    _pagingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void refresh() {
    log.info("Refreshed!");
    _pagingController.refresh();
  }
}
