import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/model_notifi.dart';

class NotificationStorage {
  static const String key = "saved_notifications";

  // Save notification
  static Future<void> saveNotification(AppNotification note) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> current = prefs.getStringList(key) ?? [];

    current.add(jsonEncode(note.toJson()));

    await prefs.setStringList(key, current);
  }

  // Load notifications
  static Future<List<AppNotification>> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> data = prefs.getStringList(key) ?? [];

    return data
        .map((e) => AppNotification.fromJson(jsonDecode(e)))
        .toList();
  }

  // Delete one
  static Future<void> deleteNotification(int index) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> data = prefs.getStringList(key) ?? [];

    if (index < data.length) {
      data.removeAt(index);
      await prefs.setStringList(key, data);
    }
  }

  // Clear all
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
