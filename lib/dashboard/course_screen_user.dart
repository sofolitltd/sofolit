import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../course/course_card.dart';
import '../db/controllers/course_controller.dart';

class CourseScreenUser extends StatelessWidget {
  const CourseScreenUser({super.key});

  @override
  Widget build(BuildContext context) {
    final CourseController courseController = Get.put(CourseController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //
            Center(
              child: SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1280),
                  padding:
                      MediaQuery.sizeOf(context).width > 1280
                          ? EdgeInsets.symmetric(vertical: 24, horizontal: 0)
                          : const EdgeInsets.all(16.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Determine number of columns based on screen size
                      int crossAxisCount = _getCrossAxisCount(
                        constraints.maxWidth,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),

                          Text('Your Courses'),
                          const SizedBox(height: 32),
                          Obx(() {
                            if (courseController.isLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              alignment: WrapAlignment.start,
                              children: [
                                for (var course in courseController.courses)
                                  SizedBox(
                                    width:
                                        (constraints.maxWidth -
                                            (crossAxisCount - 1) * 16) /
                                        crossAxisCount,
                                    child: CourseCard(course: course),
                                  ),
                              ],
                            );
                          }),
                          const SizedBox(height: 32),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to determine cross-axis count based on screen width
  int _getCrossAxisCount(double maxWidth) {
    if (maxWidth > 1200) {
      return 4;
    } else if (maxWidth > 1024) {
      return 3;
    } else if (maxWidth > 768) {
      return 3; // Large Tablets (Landscape)
    } else if (maxWidth > 600) {
      return 2; // Small Tablets (Portrait)
    } else if (maxWidth > 480) {
      return 2; // Small Mobile (Landscape)
    } else {
      return 1; // Extra Small Mobile (Portrait)
    }
  }
}
