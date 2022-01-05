import 'package:app/services/wordpress/wordpress_init.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class WordpressSearchService {
  static final Logger log = Logger("WordpressSearchService");

  static Future<PostsResults> getPostsResults(query) async {
    try {
      WPResponse res = await wpApi.search.search(args: {
        "search": query,
        "type": "post",
      });
      return PostsResults(res.data);
    } catch (e) {
      log.severe(e.toString());
      return PostsResults(List.empty());
    }
  }
}

class PostsResults {
  final List<Search> results;

  PostsResults(this.results);
}
