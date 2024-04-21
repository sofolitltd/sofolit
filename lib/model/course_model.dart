import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final String courseTitle;
  final String courseDescription;
  final String courseBatch;
  final int courseSeats;
  final int coursePrice;
  final int discountRate;
  final DateTime enrollStart;
  final DateTime enrollFinish;
  final DateTime classStartDate;
  final List<String> classSchedule;
  final List<String> instructorsList;
  final List<String> enrolledStudents;
  final String courseImage;

  CourseModel({
    required this.courseTitle,
    required this.courseDescription,
    required this.courseBatch,
    required this.courseSeats,
    required this.coursePrice,
    required this.discountRate,
    required this.enrollStart,
    required this.enrollFinish,
    required this.classStartDate,
    required this.classSchedule,
    required this.instructorsList,
    required this.enrolledStudents,
    required this.courseImage,
  });

  factory CourseModel.fromJson(QueryDocumentSnapshot<Object?> json) {
    return CourseModel(
      courseTitle: json['courseTitle'],
      courseDescription: json['courseDescription'],
      courseBatch: json['courseBatch'],
      courseSeats: json['courseSeats'],
      coursePrice: json['coursePrice'],
      discountRate: json['discountRate'],
      enrollStart: json['enrollStart'].toDate(),
      enrollFinish: json['enrollFinish'].toDate(),
      classStartDate: json['classStartDate'].toDate(),
      classSchedule: List<String>.from(json['classSchedule']),
      instructorsList: List<String>.from(json['instructorsList']),
      enrolledStudents: List<String>.from(json['enrolledStudents']),
      courseImage: json['courseImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseTitle': courseTitle,
      'courseDescription': courseDescription,
      'courseBatch': courseBatch,
      'courseSeats': courseSeats,
      'coursePrice': coursePrice,
      'discountRate': discountRate,
      'enrollStart': enrollStart,
      'enrollFinish': enrollFinish,
      'classStartDate': classStartDate,
      'classSchedule': classSchedule,
      'instructorsList': instructorsList,
      'enrolledStudents': enrolledStudents,
      'courseImage': courseImage,
    };
  }
}
