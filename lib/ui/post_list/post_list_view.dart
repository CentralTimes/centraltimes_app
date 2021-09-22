import 'package:app/models/post_model.dart';
import 'package:app/services/wordpress/wordpress_posts_service.dart';
import 'package:app/ui/preview_card/post_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logging/logging.dart';

class PostListView extends StatefulWidget {
  @override
  _PostListViewState createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  final _pagingController = PagingController<int, PostModel>(firstPageKey: 1);
  final log = new Logger("PostListView");

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () => Future.sync(() => refresh()),
        child: PagedListView.separated(
          pagingController: _pagingController,
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
        ));
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
    WordpressPostsService.clearCache();
    super.dispose();
  }

  void refresh() {
    log.info("Refreshed!");
    _pagingController.refresh();
    WordpressPostsService.clearCache();
  }
}
