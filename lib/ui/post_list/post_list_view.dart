import 'package:app/models/post_model.dart';
import 'package:app/services/wordpress/wordpress_posts_service.dart';
import 'package:app/ui/preview_card/post_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logging/logging.dart';

class PostListView extends StatefulWidget {
  @override
  _PostListViewState createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  final _pagingController = PagingController<int, PostModel>(firstPageKey: 1);
  final _scrollController = ScrollController();
  final log = new Logger("PostListView");

  bool _showRefreshButton = false;
  double _lastReversal = 0.0;

  @override
  Widget build(BuildContext context) {
    return ScrollWrapper(
      scrollController: _scrollController,
      child: RefreshIndicator(
        onRefresh: () => Future.sync(() => refresh()),
        child: PagedListView.separated(
          pagingController: _pagingController,
          scrollController: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 16),
          builderDelegate: PagedChildBuilderDelegate<PostModel>(
            itemBuilder: (context, post, index) => PostPreviewCard(post: post),
            firstPageErrorIndicatorBuilder: (context) {
              log.severe(_pagingController.error.toString());
              return Placeholder();
            },
            noItemsFoundIndicatorBuilder: (context) => Placeholder(),
            /*firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
              error: _pagingController.error,
              onTryAgain: () => refresh(),
            ),
            noItemsFoundIndicatorBuilder: (context) => EmptyListIndicator(),*/
          ),
          separatorBuilder: (context, index) => Divider(
            height: 2,
            color: Colors.grey,
            thickness: 2,
          ),
        ),
      ),
      promptAlignment: Alignment.bottomRight,
      promptReplacementBuilder: (BuildContext context, Function scrollToTop) {
        return Padding(
            padding: EdgeInsets.all(16),
            child: FloatingActionButton(
              onPressed: () {
                refresh();
                scrollToTop();
              },
              child: Icon(Icons.arrow_upward),
            ));
      },
    );
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newPage = await WordpressPostsService.getPostsPage(pageKey);
      // Final page to load if length < 10
      if (newPage.length < 10) {
        _pagingController.appendLastPage(newPage);
      } else {
        _pagingController.appendPage(newPage, pageKey + 1);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  void dispose() {
    log.info("Disposed!");
    _pagingController.dispose();
    _scrollController.dispose();
    WordpressPostsService.clearCache();
    super.dispose();
  }

  void refresh() {
    log.info("Refreshed!");
    _pagingController.refresh();
    _scrollController.animateTo(0,
        duration: Duration(seconds: 3), curve: Curves.linear);
    WordpressPostsService.clearCache();
  }
}
