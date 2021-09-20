import 'package:app/models/post_model.dart';
import 'package:app/services/wordpress/wordpress_posts_service.dart';
import 'package:app/ui/post_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PostListView extends StatefulWidget {
  @override
  _PostListViewState createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  final _pagingController =
      PagingController<int, PostModel>(firstPageKey: 1);

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
              print(_pagingController.error.toString());
              return Placeholder();
            },
            noItemsFoundIndicatorBuilder: (context) => Placeholder(),
            /*firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
              error: _pagingController.error,
              onTryAgain: () => refresh(),
            ),
            noItemsFoundIndicatorBuilder: (context) => EmptyListIndicator(),*/
          ),
          separatorBuilder: (context, index) => const SizedBox(
            height: 16,
          )),
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
    _pagingController.dispose();
    WordpressPostsService.clearCache();
    super.dispose();
  }

  @override
  void didUpdateWidget(PostListView oldWidget) {
    refresh();
    super.didUpdateWidget(oldWidget);
  }

  void refresh() {
    _pagingController.refresh();
    WordpressPostsService.clearCache();
  }
}
