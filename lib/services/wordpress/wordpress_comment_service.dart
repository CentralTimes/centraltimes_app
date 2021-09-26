import 'package:app/models/comment_model.dart';
import 'package:app/ui/list/list_page.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class WordpressCommentService {
  static WordPressAPI? api;
  static final Logger log = new Logger("WordpressCommentService");

  static final DateFormat dateFormat = DateFormat("yyyy-MM-ddThh:mm:ss");

  static void init(WordPressAPI api) {
    WordpressCommentService.api = api;
    log.info("Initialized!");
  }
}
