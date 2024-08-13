import 'package:hive/hive.dart';

class LocalStorage {
  static late Box<dynamic> box;

  static Future<void> configureBox() async {
    box = await Hive.openBox('myBox');
  }
}
