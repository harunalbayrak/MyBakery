import 'package:intl/intl.dart';

class DateData {
  static DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  static DateTime currentDate = DateTime.now();
  static String get date {
    return dateFormat.format(currentDate);
  }
}
