import 'package:intl/intl.dart';

class MyFormats {
  final _currency = NumberFormat("#,##0.00", "en_US");
  final _currencyWithoutDecimals = NumberFormat("#,##0", "en_US");
  final _double = NumberFormat("#,##0.00", "en_US");
  final _dateFormat = DateFormat('yyyy/MM/dd - hh:mm a');
  final _dateTimeFormat = DateFormat('yyyy/MM/dd - hh:mm:ss a');
  final _dateWithoutTimeFormat = DateFormat('yyyy/MM/dd');
  final _dateUepaPay = DateFormat('yyyy-MM-dd hh:mm');
  final _dateTimeFormatWithoutDoubleDots = DateFormat('yyyyMMddhhmmss');

  String currencyFormat(double value) {
    return _currency.format(value);
  }

  String currencyFormatWithOutDecimals(double value) {
    return _currencyWithoutDecimals.format(value);
  }

  String doubleFormat(double value) {
    return _double.format(value);
  }

  String dateFormat(DateTime date) {
    return _dateFormat.format(date);
  }

  String dateTimeFormat(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  String dateWithoutTimeFormat(DateTime date) {
    return _dateWithoutTimeFormat.format(date);
  }

  String dateTimeFormatWithoutDoubleDots(DateTime date) {
    return _dateTimeFormatWithoutDoubleDots.format(date);
  }

  String uepaPayDate(DateTime date) {
    return _dateUepaPay.format(date);
  }
}
