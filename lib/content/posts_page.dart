import 'package:app/models/post_model.dart';
import 'package:app/services/wordpress/wordpress_posts_service.dart';
import 'package:app/ui/post_preview_card.dart';
import 'package:flutter/material.dart';

class PostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<PostModel>>(
          future: WordpressPostsService.getPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done)
              return ListView.builder(itemBuilder: (context, i) {
                return Material(
                    child: PostPreviewCard(post: snapshot.data![i])
                );
              });
            else
              return Scaffold();
          }),
    );
  }
}
