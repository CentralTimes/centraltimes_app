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

  static int getPostIndex(int id) {
    return getPosts().indexOf(id);
  }

  static bool isPostSaved(int id) {
    return (preferences.getStringList("savedPosts") ?? [])
        .contains(id.toString());
  }

  static Future<bool> _savePostsList(List<int> idList) {
    return preferences.setStringList(
        "savedPosts", idList.map((id) => id.toString()).toList());
  }

  static Future<bool> togglePost(int id,
      {Function(int index)? onAdd, Function(int index)? onRemove}) async {
    if (isPostSaved(id)) {
      int index = getPostIndex(id);
      bool value = await removePost(id);
      onRemove!(index);
      return value;
    }
    bool value = await insertPost(id);
    onAdd!(getPostIndex(id));
    return value;
  }

  static Future<bool> togglePostByIndex(int index, int id,
      {Function(int index)? onAdd, Function(int index)? onRemove}) async {
    if (isPostSaved(id)) {
      int index = getPostIndex(id);
      bool value = await removePostByIndex(index);
      onRemove!(index);
      return value;
    }
    bool value = await insertPostAtIndex(index, id);
    onAdd!(getPostIndex(id));
    return value;
  }

  static Future<bool> insertPost(int id) async {
    List<int> idList = getPosts();
    idList.insert(0, id);
    return _savePostsList(idList);
  }

  static Future<bool> removePost(int id) async {
    List<int> idList = getPosts();
    idList.remove(id);
    return _savePostsList(idList);
  }

  static Future<bool> insertPostAtIndex(int index, int id) async {
    List<int> idList = getPosts();
    idList.insert(index, id);
    return _savePostsList(idList);
  }

  static Future<bool> removePostByIndex(int index) async {
    List<int> idList = getPosts();
    idList.removeAt(index);
    return _savePostsList(idList);
  }
}
