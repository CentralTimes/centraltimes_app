import 'package:app/models/post_model.dart';
import 'package:app/ui/list/list_page.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class WordpressPostsService {
  static WordPressAPI? api;
  static final Logger log = new Logger("WordpressPostsService");

  static final DateFormat dateFormat = DateFormat("yyyy-MM-ddThh:mm:ss");

  static Map<int, ListPage<PostModel>> pageCache = {};

  static void init(WordPressAPI api) {
    WordpressPostsService.api = api;
    log.info("Initialized!");
  }

  static Future<ListPage<PostModel>> getPostsPage(int page) async {
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
        pageCache[page] = new ListPage<PostModel>(posts, res.data.length < 10);
        log.info(
            "Fetched ${res.data.length} posts from API. (${posts.length} after blacklist)");
      }
      return pageCache[page]!;
    } catch (e) {
      log.severe(e.toString());
      return ListPage<PostModel>(List.empty(), false);
    }
  }

  static void clearCache() {
    pageCache = {};
  }

  static List<PostModel> _blacklistPosts(WPResponse res) {
    final unescape = HtmlUnescape();
    List<PostModel> posts = List.empty(growable: true);
    for (final post in res.data) {
      // Temporary fix for posts with invalid pages/formatting
      // TODO add post preprocessing service
      // Blacklist posts with video category (ID 123)
      // Blacklist posts with no pages
      if (!(post.categories.contains(123) || post.content == ""))
        posts.add(new PostModel(
            post.id,
            dateFormat.parse(post.dateGmt, true).toLocal(),
            dateFormat.parse(post.modifiedGmt, true).toLocal(),
            post.guid,
            post.slug,
            post.link,
            unescape.convert(post.title),
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
