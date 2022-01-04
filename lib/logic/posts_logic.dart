import 'package:app/models/post_model.dart';
import 'package:app/services/wordpress/wp_posts_service.dart';

class PostsLogic {
  final Map<int, PostModel> _postsCache = {};
  Future<List<PostModel>> getPageOfPosts(
      {required int pageId, required int postsPerPage, int? categoryId}) async {
    return WordpressPostService.getPageOfPosts(
        pageId: pageId, postsPerPage: postsPerPage, categoryId: categoryId);
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
}
