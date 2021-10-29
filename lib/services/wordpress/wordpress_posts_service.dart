import 'package:app/models/post_model.dart';
//import 'package:app/services/ct/ct_rules_service.dart';
import 'package:app/ui/list/list_page.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class WordpressPostService {
  static late WordPressAPI api;
  static final Logger log = Logger("WordpressPostService");

  static final DateFormat dateFormat = DateFormat("yyyy-MM-ddThh:mm:ss");

  // Caches are references to the same objects TODO test if they actually are
  static Map<int, PostModel> postCache = {};

  // 1st int category, 2nd int page number
  static Map<int, Map<int, ListPage<PostModel>>> pageCache = {};

  static void init(WordPressAPI api) {
    WordpressPostService.api = api;
    log.info("Initialized!");
  }

  static Future<ListPage<PostModel>> getPostsPage(
      int category, int page) async {
    if (pageCache.containsKey(page)) {
      log.info("Cache hit!");
    } else {
      final WPResponse res = await WordpressPostService.api.fetch('posts/',
          args: {
            "page": page,
            "per_page": 10,
            if (category != 0) "categories": category
          });

      List<PostModel> posts = _processPosts(res);
      if (!pageCache.containsKey(category)) pageCache[category] = {};
      pageCache[category]![page] =
          ListPage<PostModel>(posts, res.data.length < 10);
      log.info("Fetched ${res.data.length} posts from API.");
      // Also add the posts we got into the post cache
      for (PostModel post in posts) {
        postCache[post.id] = post;
      }
    }
    return pageCache[category]![page]!;
  }

  static Future<PostModel> getPost(int postId) async {
    if (!postCache.containsKey(postId)) {
      log.info("Attempting to fetch single post with id $postId...");
      final WPResponse res =
          await WordpressPostService.api.fetch('posts/$postId');
      postCache[postId] = _postFromMap(res.data);
    }
    return postCache[postId]!;
  }

  static void clearCache() {
    clearPostCache();
    clearPageCache();
  }

  static void clearPageCache({int category = -1}) {
    if (category != -1) {
      pageCache[category] = {};
    } else {
      pageCache = {};
    }
  }

  static void clearPostCache() {
    postCache = {};
  }

  static List<PostModel> _processPosts(WPResponse res) {
    List<PostModel> posts = [];
    /* sorry brian
    for (final post in res.data) {
      if (!CtRulesService.applyRuleList("blacklist", post)) {
        posts.add(_postFromMap(post));
      }
    }*/

    for (final post in res.data) {
      if (!post["tags"].contains(794)) {
        posts.add(_postFromMap(post));
      }
    }

    return posts;
  }

  static PostModel _postFromMap(Map<String, dynamic> postMap) {
    // We also have to interpret data as a map since we fetch with a modified
    // API, so we can't use the wordpress_api package utility class.
    final unescape = HtmlUnescape();
    return PostModel(
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
        (postMap['ct_subtitle'] as List).map((e) => e as String).toList(),
        postMap["author"],
        (postMap['ct_writer'] as List).map((e) => e as String).toList(),
        (postMap['ct_jobtitle'] as List).map((e) => e as String).toList(),
        (postMap['ct_video'] as List).map((e) => e as String).toList(),
        (postMap['ct_videographer'] as List).map((e) => e as String).toList(),
        postMap["featured_media"],
        List<int>.from(postMap["categories"] ?? []),
        List<int>.from(postMap["tags"] ?? []),
        List<int>.from(postMap["staff_name"] ?? []),
        postMap["comment_status"]);
  }
}
