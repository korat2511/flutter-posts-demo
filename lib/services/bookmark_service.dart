import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static const key = 'bookmarked_post_ids';

  BookmarkService({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;

  Future<SharedPreferences> get storage async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<Set<int>> getBookmarkedIds() async {
    final prefs = await storage;
    final list = prefs.getStringList(key);
    if (list == null) return {};
    return list.map((e) => int.tryParse(e) ?? -1).where((e) => e >= 0).toSet();
  }

  Future<bool> toggleBookmark(int postId) async {
    final ids = await getBookmarkedIds();
    final isBookmarked = ids.contains(postId);
    if (isBookmarked) {
      ids.remove(postId);
    } else {
      ids.add(postId);
    }
    final prefs = await storage;
    await prefs.setStringList(key, ids.map((e) => e.toString()).toList());
    return !isBookmarked;
  }

  Future<bool> isBookmarked(int postId) async {
    return (await getBookmarkedIds()).contains(postId);
  }
}
