import 'package:app/models/post_model.dart';
import 'package:app/services/wordpress/wp_posts_service.dart';

class PostsLogic {
  final Map<int, PostModel> _postsCache = {};
  Future<List<PostModel>> getPageOfPosts(
      {required int pageId, required int postsPerPage, int? categoryId}) async {
    List<PostModel> posts = await WordpressPostService.getPageOfPosts(
        pageId: pageId, postsPerPage: postsPerPage, categoryId: categoryId);
    for (PostModel post in posts) {
      _postsCache[post.id] = post;
    }
    return posts;
  }

  Future<PostModel> getPost({required int postId}) async {
    if (_postsCache.containsKey(postId)) return _postsCache[postId]!;
    PostModel postModel = await WordpressPostService.getPost(postId: postId);
    _postsCache[postId] = postModel;
    return postModel;
  }

  Future<List<PostModel>> getPosts({required List<int> postIds}) async {
    return Future.wait(
        postIds.map((postId) => getPost(postId: postId)).toList());
  }

  bool cacheContainsPost({required int postId}) {
    return _postsCache.containsKey(postId);
  }

  PostModel? getPostFromCache({required int postId}) {
    return _postsCache[postId];
  }

  List<PostModel?> getPostsFromCache({required List<int> postIds}) {
    return postIds.map((postId) => getPostFromCache(postId: postId)).toList();
  }

  @override
  String toString() {
    return _postsCache.toString();
  }
}
