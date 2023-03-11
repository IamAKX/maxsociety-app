import 'package:intl/intl.dart';

const String serverTimestampFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";

String formatDateOfBirth(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

String formatToServerTimestamp(DateTime date) {
  return DateFormat(serverTimestampFormat).format(date);
}

String formatFromDatepickerToDatabase(String date) {
  String datePickerFormat = 'yyyy-MM-dd HH:mm';
  DateTime dateTime = DateFormat(datePickerFormat).parse(date);
  return formatToServerTimestamp(dateTime);
}

String formatFromDatepickerToDatabaseOnlyDate(String date) {
  String datePickerFormat = 'yyyy-MM-dd';
  DateTime dateTime = DateFormat(datePickerFormat).parse(date);
  return formatToServerTimestamp(dateTime);
}
