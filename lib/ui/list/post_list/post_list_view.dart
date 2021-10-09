import 'package:app/models/post_model.dart';
import 'package:app/services/wordpress/wordpress_posts_service.dart';
import 'package:app/ui/list/infinite_list.dart';
import 'package:app/ui/list/list_page.dart';
import 'package:app/ui/list/post_list/post_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logging/logging.dart';

class PostListView extends StatefulWidget {
  final int category;

  const PostListView({Key? key, this.category = 0}) : super(key: key);
  @override
  _PostListViewState createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  final PagingController<int, PostModel> _pagingController =
      PagingController(firstPageKey: 1);
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final ListPage<PostModel> newItems =
          await WordpressPostService.getPostsPage(widget.category, pageKey);
      if (newItems.isLast) {
        _pagingController.appendLastPage(newItems.items);
      } else {
        _pagingController.appendPage(newItems.items, pageKey + 1);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: RefreshIndicator(
        onRefresh: () async => _pagingController.refresh(),
        child: PagedListView.separated(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<PostModel>(
                itemBuilder: (context, data, index) =>
                    PostPreviewCard(post: data)),
            separatorBuilder: (context, index) => Padding(padding: EdgeInsets.all(8))),
      ),
    );
  }
}

/*
class PostListView extends StatefulWidget {
  final int category;

  const PostListView({Key? key, this.category = 0}) : super(key: key);

  @override
  _PostListViewState createState() => _PostListViewState(category);
}

class _PostListViewState extends State<PostListView> {
  final int category;
  @override
  final log = new Logger("PostListView");

  _PostListViewState(this.category);

  @override
  Widget buildItem(context, data, index) {
    return PostPreviewCard(post: data);
  }

  @override
  Future<ListPage<PostModel>> fetchPage(int pageKey) {
    return WordpressPostService.getPostsPage(category, pageKey);
  }

  @override
  void dispose() {
    WordpressPostService.clearPageCache(category: category);
    super.dispose();
  }

  @override
  void refresh() {
    WordpressPostService.clearPageCache(category: category);
    super.refresh();
  }
}
*/