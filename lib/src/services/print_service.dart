import 'package:e_price/src/helpers/printer.dart';
import 'package:e_price/src/screen.dart';
import 'package:flutter/services.dart';

class PrinterService {
  Future<String?> printText(String content, String barcode) async {
    try {
      var result = await PrinterManager.startPrinting(content, barcode); // 开启黑标
      return null;
    } catch (e) {
      print("FALLO LA IMPRESORA: '${e}'.");
      return e.toString();
    }
  }
}
