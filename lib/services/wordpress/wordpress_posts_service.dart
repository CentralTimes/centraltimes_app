import 'package:app/models/post_model.dart';
import 'package:app/ui/list/list_page.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class WordpressPostService {
  static WordPressAPI? api;
  static final Logger log = new Logger("WordpressPostService");

  static final DateFormat dateFormat = DateFormat("yyyy-MM-ddThh:mm:ss");

  static Map<int, ListPage<PostModel>> pageCache = {};

  static void init(WordPressAPI api) {
    WordpressPostService.api = api;
    log.info("Initialized!");
  }

  static Future<ListPage<PostModel>> getPostsPage(int page) async {
    try {
      if (pageCache.containsKey(page)) {
        log.info("Cache hit!");
      } else {
        final WPResponse res =
        await WordpressPostService.api!.fetch('posts/', args: {
          "page": page,
          "per_page": 10,
        });

        List<PostModel> posts = _blacklistPosts(res);
        pageCache[page] = new ListPage<PostModel>(posts, res.data.length < 10);
        log.info(
            "Fetched ${res.data.length} posts from API. (${posts
                .length} after blacklist)");
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

      // We also have to interpret data as a map since we fetch with a modified
      // API, so we can't use the wordpress_api package utility class.
      if (!(List<int>.from(post["categories"] ?? []).contains(123) ||
          post["content"] == ""))
        posts.add(new PostModel(
            post["id"],
            dateFormat.parse(post["date_gmt"], true).toLocal(),
            dateFormat.parse(post["modified_gmt"], true).toLocal(),
            post['guid']?['rendered'],
            post["slug"],
            post["link"],
            unescape.convert(post['title']?['rendered']),
            post['content']?['rendered'],
            post["ct_raw"],
            post['excerpt']?['rendered'],
            post["author"],
            post["featured_media"],
            List<int>.from(post["categories"] ?? []),
            List<int>.from(post["tags"] ?? []),
            post["comment_status"]));
    }
    return posts;
  }
}
