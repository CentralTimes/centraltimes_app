import 'package:app/models/post_model.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class WordpressPostsService {
  static WordPressAPI? api;
  static final Logger log = new Logger("WordpressPostsService");

  static Map<int, PostsPage> pageCache = {};

  static void init(WordPressAPI api) {
    WordpressPostsService.api = api;
    log.info("Initialized!");
  }

  static Future<PostsPage> getPostsPage(int page) async {
    try {
      if (pageCache.containsKey(page)) {
        log.info("Cache hit!");
      } else {
        final WPResponse res =
            await WordpressPostsService.api!.posts.fetch(args: {
          "page": page,
          "per_page": 10,
        });

        List<PostModel> posts = _blacklistPosts(res);
        pageCache[page] = new PostsPage(posts, res.data.length < 10);
        log.info("Fetched ${posts.length} posts from API.");
      }
      return pageCache[page]!;
    } catch (e) {
      log.severe(e.toString());
      return PostsPage(List.empty(), false);
    }
  }

  static void clearCache() {
    pageCache = {};
  }

  static List<PostModel> _blacklistPosts(WPResponse res) {
    List<PostModel> posts = List.empty(growable: true);
    for (final post in res.data) {
      // Temporary fix for posts with invalid content/formatting
      // TODO add post preprocessing service
      // Blacklist posts with video category (ID 123)
      // Blacklist posts with no content
      if (!(post.categories.contains(123) || post.content == ""))
        log.warning(post.content);
        posts.add(new PostModel(
            post.id,
            DateTime.parse(post.dateGmt),
            DateTime.parse(post.modified),
            post.guid,
            post.slug,
            post.link,
            post.title,
            post.content,
            post.excerpt,
            post.author,
            post.featuredMedia,
            post.categories,
            post.tags,
            post.commentStatus));
    }
    return posts;
  }
}

class PostsPage {
  final List<PostModel> posts;
  final bool isLast;

  PostsPage(this.posts, this.isLast);
}
