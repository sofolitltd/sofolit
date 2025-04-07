import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  String? courseID;
  String title;
  String slug;
  String description;
  String batch;
  int seats;
  int price;
  int discount;
  DateTime enrollStart;
  DateTime enrollEnd;
  DateTime classStartDate;
  List<String> classSchedule;
  List<String> requirements;
  List<String> participants;
  String imageUrls;
  String videoUrl;
  bool active;

  Course({
    this.courseID,
    required this.title,
    required this.slug,
    required this.description,
    required this.batch,
    required this.seats,
    required this.price,
    required this.discount,
    required this.enrollStart,
    required this.enrollEnd,
    required this.classStartDate,
    required this.classSchedule,
    required this.requirements,
    required this.participants,
    required this.imageUrls,
    required this.videoUrl,
    required this.active,
  });

  // Factory to create from JSON
  factory Course.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    return Course(
      courseID: doc.id,
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      batch: json['batch'],
      seats: json['seats'],
      price: json['price'],
      discount: json['discount'],
      enrollStart: (json['enrollStart'] as Timestamp).toDate(),
      enrollEnd: (json['enrollEnd'] as Timestamp).toDate(),
      classStartDate: (json['classStartDate'] as Timestamp).toDate(),
      classSchedule: List<String>.from(json['classSchedule']),
      requirements: List<String>.from(json['requirements']),
      participants: List<String>.from(json['participants']),
      imageUrls: json['imageUrls'],
      videoUrl: json['videoUrl'],
      active: json['active'],
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'slug': slug,
      'description': description,
      'batch': batch,
      'seats': seats,
      'price': price,
      'discount': discount,
      'enrollStart': enrollStart,
      'enrollEnd': enrollEnd,
      'classStartDate': classStartDate,
      'classSchedule': classSchedule,
      'requirements': requirements,
      'participants': participants,
      'imageUrls': imageUrls,
      'videoUrl': videoUrl,
      'active': active,
    };
  }
}
