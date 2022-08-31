import 'package:app/models/tab_category_model.dart';
import 'package:app/services/wordpress/wordpress_init.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class CtTabCategoryService {
  static final Logger log = Logger("CtTabCategoryService");

  static Future<dynamic> getTabCategories() async {
    WPResponse res;
    try {
      res = await wpApi.fetch('tab-categories', namespace: 'centraltimes/v1');
      return (res.data as List)
          .map((e) => TabCategoryModel(e["name"], e["id"]))
          .toList();
    } catch (e) {
      return null;
    }
  }
}
