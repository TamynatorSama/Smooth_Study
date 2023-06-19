import 'package:hive_flutter/hive_flutter.dart';
import 'package:smooth_study/utils/constants.dart';

class HiveInitializer{
  static late Box box;

  static Future initialize()async {
    box = await Hive.openBox(smoothStudyBox);
    // box.containsKey("jsonPayload")
    
  }


}