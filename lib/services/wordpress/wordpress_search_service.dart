import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class WordpressSearchService {
  static WordPressAPI? api;
  static final Logger log = new Logger("WordpressSearchService");

  static void init(WordPressAPI api) {
    WordpressSearchService.api = api;
    log.info("Initialized!");
  }

  static Future<PostsResults> getPostsResults(query) async {
    try {
      WPResponse res = await api!.search.search(args: {
        "search": query,
        "type": "post",
      });
      return PostsResults(res.data);
    } catch (e) {
      log.severe(e.toString());
      return new PostsResults(List.empty());
    }
  }
}

class PostsResults {
  final List<Search> results;

  PostsResults(this.results);
}
