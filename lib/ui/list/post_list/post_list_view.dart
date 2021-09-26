import 'package:app/models/post_model.dart';
import 'package:app/services/wordpress/wordpress_posts_service.dart';
import 'package:app/ui/list/infinite_list.dart';
import 'package:app/ui/list/list_page.dart';
import 'package:app/ui/list/post_list/post_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class PostListView extends StatefulWidget {
  @override
  _PostListViewState createState() => _PostListViewState();
}

class _PostListViewState extends InfiniteListState<PostModel> {
  @override
  final log = new Logger("PostListView");

  @override
  Widget buildItem(context, data, index) {
    return PostPreviewCard(post: data);
  }

  @override
  Future<ListPage<PostModel>> fetchPage(int pageKey) {
    return WordpressPostService.getPostsPage(pageKey);
  }

  @override
  void dispose() {
    WordpressPostService.clearCache();
    super.dispose();
  }

  @override
  void refresh() {
    WordpressPostService.clearCache();
    super.refresh();
  }
}
