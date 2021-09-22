import 'package:app/models/post_model.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class WordpressPostsService {
  static WordPressAPI? api;
  static final Logger log = new Logger("WordpressPostsService");

  static Map<int, List<PostModel>> pageCache = {};

  static void init(WordPressAPI api) {
    WordpressPostsService.api = api;
    log.info("Initialized!");
  }

  static Future<List<PostModel>> getPostsPage(int page) async {
    try {
      if (pageCache.containsKey(page)) {
        log.info("Cache hit!");
      } else {
        final WPResponse res =
            await WordpressPostsService.api!.posts.fetch(args: {
          "page": page,
          "per_page": 10,
        });

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
              post.commentStatus));
        }
        pageCache[page] = posts;
        log.info("Fetched ${posts.length} posts from API.");
      }
      return pageCache[page]!;
    } catch (e) {
      log.severe(e.toString());
      return List.empty();
    }
  }

  static void clearCache() {
    pageCache = {};
  }
}
