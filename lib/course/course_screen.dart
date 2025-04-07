import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/app_footer.dart';
import '../db/controllers/course_controller.dart';
import 'course_card.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

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
                  padding: MediaQuery.sizeOf(context).width > 1280
                      ? EdgeInsets.symmetric(vertical: 24, horizontal: 0)
                      : const EdgeInsets.all(16.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Determine number of columns based on screen size
                      int crossAxisCount =
                          _getCrossAxisCount(constraints.maxWidth);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.black12.withValues(alpha: .05),
                            ),
                            height: 150,
                            padding: const EdgeInsets.all(24),
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //
                                Text(
                                  'পছন্দের দক্ষতা অর্জনের জন্য সেরা অনলাইন প্ল্যাটফর্ম',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 8),
                                //
                                Text(
                                  'আপনার পছন্দের কোর্সটি বেছে নিন আর দক্ষতা অর্জন করে হয়ে উঠুন স্বাবলম্বী।',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(),
                                ),
                                //
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          Obx(() {
                            if (courseController.isLoading.value) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            return Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              alignment: WrapAlignment.start,
                              children: [
                                for (var course in courseController.courses)
                                  SizedBox(
                                    width: (constraints.maxWidth -
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

            //
            ...[
              const SizedBox(height: 40),
              const AppFooter(),
            ],
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
