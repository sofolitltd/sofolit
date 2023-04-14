import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DTFormatter {
  //date and time
  static dateTimeFormat(timestamp) {
    String t = '';
    var tm = timestamp as Timestamp;
    t = DateFormat('EEE, dd MMMM, yyyy  - hh:mm a').format(tm.toDate());
    return t.toString();
  }

  //date
  static dateFormat(timestamp) {
    String t = '';
    var tm = timestamp as Timestamp;
    t = DateFormat('EEE, dd MMMM').format(tm.toDate());
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
  static dayFormat(timestamp) {
    String t = '';
    var tm = timestamp as Timestamp;
    t = DateFormat('dd').format(tm.toDate());
    return t.toString();
  }
}
