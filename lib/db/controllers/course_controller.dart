import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../model/course_model.dart';
import '../repositories/course_repository.dart';

class CourseController extends GetxController {
  final CourseRepository _courseRepository = CourseRepository();

  // Form controllers
  final titleController = TextEditingController();
  final slugController = TextEditingController();
  final descriptionController = TextEditingController();
  final batchController = TextEditingController();
  final seatsController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();
  final imageUrlController = TextEditingController();

  var enrollStart = DateTime.now().obs;
  var enrollEnd = DateTime.now().add(const Duration(days: 30)).obs;

  // Course data
  var courses = <Course>[].obs;
  var isLoading = false.obs;
  var selectedCourse = Rxn<Course>();

  @override
  void onInit() {
    super.onInit();
    fetchCourses();
  }

  // Fetch all courses
  void fetchCourses() async {
    try {
      isLoading.value = true;
      var fetchedCourses = await _courseRepository.getCourses();
      courses.assignAll(fetchedCourses);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to load courses');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch a course by ID
  void fetchCourseBySlug(String slug) async {
    try {
      isLoading.value = true;
      var fetchedCourse = await _courseRepository.getCourseBySlug(slug);
      selectedCourse.value = fetchedCourse;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to load course');
    } finally {
      isLoading.value = false;
    }
  }

  // Add a new course from form inputs
  Future<void> addCourseFromForm() async {
    try {
      var course = Course(
        title: titleController.text,
        slug: slugController.text,
        description: descriptionController.text,
        batch: batchController.text,
        seats: int.parse(seatsController.text),
        price: int.parse(priceController.text),
        discount: int.parse(discountController.text),
        enrollStart: enrollStart.value,
        enrollEnd: enrollEnd.value,
        classStartDate: DateTime.now(),
        classSchedule: [],
        requirements: [],
        participants: [],
        imageUrls: imageUrlController.text,
        videoUrl: '',
        active: true,
      );

      await addCourse(course);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to add course');
    }
  }

  // Add a new course (general method)
  Future<void> addCourse(Course course) async {
    try {
      isLoading.value = true;
      await _courseRepository.addCourse(course);
      fetchCourses();
      Fluttertoast.showToast(msg: 'Course added successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to add course');
    } finally {
      isLoading.value = false;
    }
  }

  // Update a course
  Future<void> updateCourse(Course course) async {
    try {
      isLoading.value = true;
      await _courseRepository.updateCourse(course);
      fetchCourses();
      Fluttertoast.showToast(msg: 'Course updated successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to update course');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete a course
  Future<void> deleteCourse(String courseID) async {
    try {
      isLoading.value = true;
      await _courseRepository.deleteCourse(courseID);
      fetchCourses();
      Fluttertoast.showToast(msg: 'Course deleted successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to delete course');
    } finally {
      isLoading.value = false;
    }
  }
}
