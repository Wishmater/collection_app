import 'package:intl/intl.dart';


extension DateFormatTry on DateFormat {
  String? tryFormat(DateTime? dateTime) {
    if (dateTime==null) return null;
    return format(dateTime);
  }
  DateTime? tryParse(String? string) {
    if (string==null) return null;
    return parse(string);
  }
}