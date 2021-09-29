import 'package:app/models/comment_model.dart';
import 'package:app/ui/list/infinite_list.dart';
import 'package:app/ui/list/list_page.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class CommentListView extends StatefulWidget {
  @override
  _CommentListViewState createState() => _CommentListViewState();
}
class _CommentListViewState extends InfiniteListState<CommentModel> {
  @override
  final log = new Logger("CommentListView");

  @override
  Widget buildItem(context, data, index) {
    return Placeholder();
  }

  @override
  Future<ListPage<CommentModel>> fetchPage(int pageKey) {
    return Future(() => ListPage(List.empty(), true));
  }
}
