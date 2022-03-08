import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

@immutable
class TimeBox {
  static Box? box;
  static DateTime? date;

  // boxのデータをクラスに反映
  // Boxが存在しない場合はnull
  static Future<void> init() async {
    box = await Hive.openBox('timeBox');
    if (box!.isNotEmpty) {
      date = box!.get('date');
    }
  }

  static DateTime? getDate() {
    return date;
  }

  static void update(DateTime time) {
    box!.put('date', time);
  }
}
