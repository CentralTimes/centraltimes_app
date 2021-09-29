import 'package:app/models/post_model.dart';
import 'package:app/services/saved_posts_service.dart';
import 'package:app/services/wordpress/wordpress_posts_service.dart';
import 'package:app/ui/list/post_list/post_preview_card.dart';
import 'package:app/ui/media_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';

class SavedListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SavedListViewState();
}

class _SavedListViewState extends State<SavedListView> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    List<int> savedPostIds = SavedPostsService.getPosts();
    return ScrollWrapper(
      scrollController: _scrollController,
      child: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 0),
            itemCount: savedPostIds.length,
            itemBuilder: (context, i) {
              return FutureBuilder<PostModel>(
                future: WordpressPostService.getPost(savedPostIds[i]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return PostPreviewCard(post: snapshot.data!);
                  } else {
                    return MediaLoadingIndicator();
                  }
                },
              );
            },
            separatorBuilder: (context, index) => Divider(
              height: 2,
              color: Colors.grey,
              thickness: 2,
            ),
          )),
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
  }
}
