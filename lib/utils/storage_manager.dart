import 'package:hive_flutter/hive_flutter.dart';

class StorageManager {
  static late Box themeBox;

  static Future initialize() async {
    themeBox = await Hive.openBox('themeBox');
  }

  static void saveData(String key, dynamic value) async {
    themeBox.put(
      key,
      value,
    );
  }

  static Future<dynamic> readData(String key) async {
    themeBox.containsKey(key);
    return await themeBox.get(key, defaultValue: 'light');
  }

  static Future<bool> deleteData(String key) async {
   await themeBox.delete(key);
   return true;
  }
}
