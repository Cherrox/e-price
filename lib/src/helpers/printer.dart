import 'package:flutter/services.dart';

class PrinterManager {
  static const MethodChannel _channel = MethodChannel('com.example/printer');

  // 获取打印机版本号
  static Future<String?> getPrinterVersion(String value) async {
    final String? version =
        await _channel.invokeMethod('getPrinterVer', {"content": value});
    return version;
  }

  // 开始打印 卡板标
  static Future<String?> startPrinting(
    String content,
    String barcode,
    String price,
    String date,
    String others,
  ) async {
    try {
      bool containsChinese(String text) {
        return RegExp('[\u4e00-\u9fa5]').hasMatch(text);
      }

      bool hasChinese = containsChinese(content.toString().trim());
      if (!hasChinese) {
        var result = await _channel.invokeMethod('startPrinting', {
          "itemName": content,
          "barcode": barcode,
          "price": price,
          "date": date,
          "others": others,
        });
        print("result: $result");
      } else {
        // EasyLoading.showToast('存在中文字符 不支持打印!',
        //     duration: const Duration(seconds: 5));
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
