import 'package:app/models/post_model.dart';
import 'package:wordpress_api/wordpress_api.dart';

class WordpressPostsService {

  static WordPressAPI? api;

  static void init(WordPressAPI api) {
    WordpressPostsService.api = api;
  }
  // Temporary bashing together until I replace the package with a custom
  // library specifically for SNO deployments.
  static Future<List<PostModel>> getPosts() async {
    final WPResponse res = await WordpressPostsService.api!.posts.fetch();
    List<PostModel> posts = List.empty(growable: true);
    for (final post in res.data) {
      posts.add(new PostModel(
          post.id,
          DateTime.parse(post.dateGmt),
          DateTime.parse(post.modified),
          post.guid,
          post.slug,
          post.title,
          post.content,
          post.excerpt,
          post.author,
          post.featuredMedia,
          post.categories,
          post.tags,
          post.commentStatus
      ));
    }
    return posts;
  }
}