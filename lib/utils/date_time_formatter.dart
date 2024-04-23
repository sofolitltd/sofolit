import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DTFormatter {
  //date and time
  static dateWithTime(DateTime timestamp) {
    String t = '';
    t = DateFormat('dd MMMM, yyyy - hh:mm a').format(timestamp);
    return t.toString();
  }

  //date with day
  static dateWithDay(timestamp) {
    String t = '';
    t = DateFormat('dd MMMM, yyyy (EEEE)').format(timestamp);
    return t.toString();
  }

  // date
  static dateShort(timestamp) {
    String t = '';
    t = DateFormat('dd MMMM').format(timestamp);
    return t.toString();
  }

  static dateFull(timestamp) {
    String t = '';
    t = DateFormat('dd MMM, yyyy').format(timestamp);
    return t.toString();
  }

// time
  static timeFormat(timestamp) {
    String t = '';
    var tm = timestamp as Timestamp;
    t = DateFormat('hh:mm a').format(tm.toDate());
    return t.toString();
  }

  // time
  static remainingDay(timestamp) {
    DateTime t;
    Timestamp ts = timestamp as Timestamp;
    DateTime dateTime = ts.toDate();
    t = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return t;
  }
}
