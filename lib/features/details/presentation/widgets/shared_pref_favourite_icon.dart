// lib/core/utils/favorite_manager.dart
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteManager {
  static const String _prefix = 'fav_';

  static Future<bool> getFavoriteState(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_prefix$productId') ?? false;
  }

  static Future<void> setFavoriteState(String productId, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefix$productId', value);
  }

  static Future<List<String>> getAllFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final favKeys = keys.where((k) => k.startsWith(_prefix)).toList();
    final List<String> ids = [];
    for (var k in favKeys) {
      if (prefs.getBool(k) == true) {
        ids.add(k.replaceFirst(_prefix, ''));
      }
    }
    return ids;
  }

  static Future<void> removeFavorite(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix$productId');
  }

  static Future<void> clearAllFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_prefix));
    for (var k in keys) {
      await prefs.remove(k);
    }
  }
}
