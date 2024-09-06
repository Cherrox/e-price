import 'package:flutter/services.dart';

class PrinterService {
  static const MethodChannel _channel = MethodChannel('e.price.gs/printer');

  Future<void> printText(String content) async {
    try {
      await _channel.invokeMethod('printText', {'content': content});
    } on PlatformException catch (e) {
      print("Failed to print: '${e.message}'.");
    }
  }
}
