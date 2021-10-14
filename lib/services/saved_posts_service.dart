import 'package:shared_preferences/shared_preferences.dart';

class SavedPostsService {
  static late SharedPreferences preferences;

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static List<int> getPosts() {
    return (preferences.getStringList("savedPosts") ?? [])
        .map((e) => int.parse(e))
        .toList();
  }

  static bool isPostSaved(int id) {
    return (preferences.getStringList("savedPosts") ?? [])
        .contains(id.toString());
  }

  static Future<bool> togglePost(int id) async {
    List<String> idList = (preferences.getStringList("savedPosts") ?? []);
    if (idList.contains(id.toString())) {
      idList.remove(id.toString());
    } else {
      idList.add(id.toString());
    }
    return await preferences.setStringList("savedPosts", idList);
  }

  static Future<bool> insertPost(int id) async {
    List<String> idList = (preferences.getStringList("savedPosts") ?? []);
    idList.add(id.toString());
    return await preferences.setStringList("savedPosts", idList);
  }

  static Future<bool> removePost(int id) async {
    List<String> idList = (preferences.getStringList("savedPosts") ?? []);
    idList.remove(id.toString());
    return await preferences.setStringList("savedPosts", idList);
  }
}
