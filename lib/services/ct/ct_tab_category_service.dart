import 'package:app/models/tab_category_model.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class CtTabCategoryService {
  static WordPressAPI? api;
  static final Logger log = new Logger("CtTabCategoryService");

  static List<TabCategoryModel> cache = [];

  static void init(WordPressAPI api) {
    CtTabCategoryService.api = api;
    log.info("Initialized!");
  }

  static Future<List<TabCategoryModel>> getTabCategories() async {
    if (cache.isEmpty) {
      final WPResponse res = await CtTabCategoryService.api!
          .fetch('tab-categories', namespace: 'centraltimes/v1');
      cache = (res.data as List)
          .map((e) => TabCategoryModel(e["name"], e["id"]))
          .toList();
    }
    return cache;
  }
}
