// import 'package:flutter/services.dart';

// class PrinterService {
//   static const MethodChannel _channel = MethodChannel('printer_plugin');

//   Future<void> print(String data) async {
//     try {
//       await _channel.invokeMethod('print', {'data': data});
//     } on PlatformException catch (e) {
//       print("Failed to print: '${e.message}'.");
//     }
//   }

//   Future<String?> getVersion() async {
//     try {
//       final String version = await _channel.invokeMethod('getVersion');
//       return version;
//     } on PlatformException catch (e) {
//       print("Failed to get version: '${e.message}'.");
//       return null;
//     }
//   }
// }

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
