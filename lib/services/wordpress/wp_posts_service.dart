import 'package:app/models/post_model.dart';
import 'package:app/services/wordpress/wordpress_init.dart';
//import 'package:app/services/ct/ct_rules_service.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class WordpressPostService {
  static final Logger log = Logger("WordpressPostService");

  static final DateFormat _dateFormat = DateFormat("yyyy-MM-ddThh:mm:ss");

  static Future<List<PostModel>> getPageOfPosts(
      {required int pageId, required int postsPerPage, int? categoryId}) async {
    //TODO: Implement error handling & null safety
    final WPResponse res = await wpApi.fetch('posts/', args: {
      "page": pageId,
      "per_page": postsPerPage,
      if (categoryId != null && categoryId != 0) "categories": categoryId,
    });
    // We also have to interpret data as a map since we fetch with a modified
    // API, so we can't use the wordpress_api package utility class.
    List<PostModel> posts = [];
    for (Map<String, dynamic> postMap in res.data) {
      posts.add(_postFromMap(postMap));
    }
    return posts;
  }

  static Future<PostModel> getPost({required int postId}) async {
    //TODO: Implement error handling & null safety
    final WPResponse res = await wpApi.fetch('posts/$postId');
    return _postFromMap(res.data);
  }

  static PostModel _postFromMap(Map<String, dynamic> postMap) {
    // We also have to interpret data as a map since we fetch with a modified
    // API, so we can't use the wordpress_api package utility class.
    return PostModel(
        postMap["id"],
        _dateFormat.parse(postMap["date_gmt"], true).toLocal(),
        _dateFormat.parse(postMap["modified_gmt"], true).toLocal(),
        postMap['guid']?['rendered'],
        postMap["slug"],
        postMap["link"],
        HtmlUnescape().convert(postMap['title']?['rendered']),
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
