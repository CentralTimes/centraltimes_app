import 'package:app/models/staff_name_model.dart';
import 'package:logging/logging.dart';
import 'package:wordpress_api/wordpress_api.dart';

class WordpressStaffNameService {
  static WordPressAPI? api;
  static final Logger log = new Logger("WordpressPostService");

  static Map<int, StaffNameModel> staffNameCache = {};

  static void init(WordPressAPI api) {
    WordpressStaffNameService.api = api;
    log.info("Initialized!");
  }

  static Future<StaffNameModel> getStaffName(int id) async {
    if (!staffNameCache.containsKey(id)) {
      WPResponse res = await WordpressStaffNameService.api!.fetch('staff_name/$id');
      staffNameCache[id] = StaffNameModel(res.data["id"], res.data["name"].trim(),
          res.data["description"].trim());
    }
    return staffNameCache[id]!;
  }
}
