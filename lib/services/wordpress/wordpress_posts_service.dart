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

  // Caches are references to the same objects TODO test if they actually are
  static Map<int, PostModel> postCache = {};
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
            "Fetched ${res.data.length} posts from API. (${posts.length} after blacklist)");
        // Also add the posts we got into the post cache
        for (PostModel post in posts) postCache[post.id] = post;
      }
      return pageCache[page]!;
    } catch (e) {
      log.severe(e.toString());
      return ListPage<PostModel>(List.empty(), false);
    }
  }

  static Future<PostModel> getPost(int postId) async {
    if (!postCache.containsKey(postId)) {
      final WPResponse res =
      await WordpressPostService.api!.fetch('posts/$postId');
      postCache[postId] = _postFromMap(res.data);
    }
    return postCache[postId]!;
  }

  static void clearCache() {
    postCache = {};
    pageCache = {};
  }

  static List<PostModel> _blacklistPosts(WPResponse res) {
    List<PostModel> posts = [];
    for (final post in res.data) {
      // Temporary fix for posts with invalid pages/formatting
      // TODO add featured content support
      // Blacklist posts with video category (ID 123)
      // Blacklist posts with no pages
      if (!(List<int>.from(post["categories"] ?? []).contains(123) ||
          post["content"].toString().trim() == ""))
        posts.add(_postFromMap(post));
    }
    return posts;
  }

  static PostModel _postFromMap(Map<String, dynamic> postMap) {
    // We also have to interpret data as a map since we fetch with a modified
    // API, so we can't use the wordpress_api package utility class.
    final unescape = HtmlUnescape();
    return new PostModel(
        postMap["id"],
        dateFormat.parse(postMap["date_gmt"], true).toLocal(),
        dateFormat.parse(postMap["modified_gmt"], true).toLocal(),
        postMap['guid']?['rendered'],
        postMap["slug"],
        postMap["link"],
        unescape.convert(postMap['title']?['rendered']),
        postMap['content']?['rendered'],
        postMap["ct_raw"],
        postMap['excerpt']?['rendered'],
        postMap["author"],
        postMap["featured_media"],
        List<int>.from(postMap["categories"] ?? []),
        List<int>.from(postMap["tags"] ?? []),
        List<int>.from(postMap["staff_name"] ?? []),
        postMap["comment_status"]);
  }
}
