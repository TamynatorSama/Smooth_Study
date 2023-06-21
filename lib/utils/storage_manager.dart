import 'package:hive_flutter/hive_flutter.dart';

class StorageManager {
  static void saveData(String key, dynamic value) async {
    final prefs =  await Hive.openBox('theme');

      prefs.put(key, value);
  }

  static Future<dynamic> readData(String key) async {
    final prefs =  await Hive.openBox('theme');
    dynamic obj = prefs.get(key);
    return obj;
  }

  static Future<bool> deleteData(String key) async {
    final prefs =  await Hive.openBox('theme');
    await prefs.delete(key);
    return true;
  }
}