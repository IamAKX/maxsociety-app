import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

const String serverTimestampFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";

String formatDateOfBirth(DateTime date) {
  try {
    return DateFormat('dd/MM/yyyy').format(date);
  } catch (e) {
    return '';
  }
}

String formatToServerTimestamp(DateTime date) {
  try {
    return DateFormat(serverTimestampFormat).format(date);
  } catch (e) {
    return '';
  }
}

DateTime parseServerTimestamp(String date) {
  try {
    return DateFormat(serverTimestampFormat).parse(date);
  } catch (e) {
    log(date + ':' + e.toString());
    return DateTime.now();
  }
}

String formatFromDatepickerToDatabase(String date) {
  try {
    String datePickerFormat = 'yyyy-MM-dd HH:mm';
    DateTime dateTime = DateFormat(datePickerFormat).parse(date);
    return formatToServerTimestamp(dateTime);
  } catch (e) {
    return '';
  }
}

String formatFromDatepickerToDatabaseOnlyDate(String date) {
  try {
    String datePickerFormat = 'yyyy-MM-dd';
    DateTime dateTime = DateFormat(datePickerFormat).parse(date);
    return formatToServerTimestamp(dateTime);
  } catch (e) {
    return '';
  }
}

String eventDateToDate(String date) {
  try {
    String dateFormat = 'dd MMM, yyyy';
    DateTime dateTime = DateFormat(serverTimestampFormat).parse(date);
    return DateFormat(dateFormat).format(dateTime);
  } catch (e) {
    return '';
  }
}

String eventDateToDateTime(String date) {
  try {
    String dateFormat = "dd MMM, yyyy 'at' hh:mm aa";
    DateTime dateTime = DateFormat(serverTimestampFormat).parse(date);
    return DateFormat(dateFormat).format(dateTime);
  } catch (e) {
    return '';
  }
}

String eventTimesAgo(String date) {
  try {
    DateTime dateTime = DateFormat(serverTimestampFormat).parse(date);
    return timeago.format(dateTime);
  } catch (e) {
    return '';
  }
}
