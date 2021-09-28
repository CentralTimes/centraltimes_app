import 'package:shared_preferences/shared_preferences.dart';

class SavedPostsService {
  static SharedPreferences? preferences;

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static List<int> getPosts() {
    return (preferences!.getStringList("savedPosts") ?? [])
        .map((e) => int.parse(e))
        .toList();
  }

  static Future<bool> insertPost(int id) async {
    List<String> idList = (preferences!.getStringList("savedPosts") ?? []);
    idList.add(id.toString());
    return await preferences!.setStringList("savedPosts", idList);
  }

  static Future<bool> removePost(int id) async {
    List<String> idList = (preferences!.getStringList("savedPosts") ?? []);
    idList.remove(id);
    return await preferences!.setStringList("savedPosts", idList);
  }
}
