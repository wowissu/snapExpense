import 'package:intl/intl.dart';

class CurrencyHelper {
  static void init() {
    Intl.defaultLocale = "en_NZ";
  }

  // new zealand currency format
  static final symbolInNZFormat = NumberFormat.currency(locale: "en_NZ", symbol: '\$', decimalDigits: 2);

  // the default currency format
  static final _defaultFormat = symbolInNZFormat;

  // the current currency format
  static NumberFormat _currentFormat = _defaultFormat;

  // format the value with the current format
  static String format(num value) {
    return _currentFormat.format(value);
  }

  // set the current format
  static void setCurrentFormat(NumberFormat format) {
    _currentFormat = format;
  }
}
