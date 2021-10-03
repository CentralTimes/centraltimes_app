import 'package:app/models/post_model.dart';
import 'package:app/services/wordpress/wordpress_posts_service.dart';
import 'package:app/ui/list/infinite_list.dart';
import 'package:app/ui/list/list_page.dart';
import 'package:app/ui/list/post_list/post_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class PostListView extends StatefulWidget {
  final int category;

  const PostListView({Key? key, this.category = 0}) : super(key: key);

  @override
  _PostListViewState createState() => _PostListViewState(category);
}

class _PostListViewState extends InfiniteListState<PostModel> {
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
