import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/model/benefit_model.dart';
import '../components/app_footer.dart';
import '../course/course_card.dart';
import '../db/controllers/course_controller.dart';
import '../model/course_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1280),
                padding: MediaQuery.sizeOf(context).width > 1280
                    ? EdgeInsets.symmetric(vertical: 24, horizontal: 0)
                    : const EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 700) {
                      // Mobile layout
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // 1st
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildDetailsBox(context, isMobile: true),
                                  // const SizedBox(height: 16),
                                  _buildImageBox(context, isMobile: true),
                                ],
                              ),
                            ),
                            //
                            _buildCourseList(),
                            //
                            _buildBenefitList(),
                          ],
                        ),
                      );
                    } else {
                      // Desktop layout
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1st
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: _buildDetailsBox(context,
                                        isMobile: false),
                                  ),
                                  // const SizedBox(width: 16),
                                  Expanded(
                                    flex: 1,
                                    child: _buildImageBox(context,
                                        isMobile: false),
                                  ),
                                ],
                              ),
                            ),
                            //
                            _buildCourseList(),
                            //
                            _buildBenefitList(),
                          ],
                        ),
                      );
                    }
                  },
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
}

//
_buildDetailsBox(BuildContext context, {required bool isMobile}) {
  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.black12.withValues(alpha: .05),
    ),
    height: isMobile ? 300 : 450,
    padding: EdgeInsets.all(isMobile ? 16 : 24),
    child: Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        //
        Text(
          'সফলতা অর্জনের জন্য,\nনিজেকে তৈরি করুন!',
          style: TextStyle(
            fontSize: isMobile ? 32 : 40,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),

        const SizedBox(height: 16),

        //
        Text(
          'পছন্দের কোর্সে যোগ দিন এবং দক্ষতা অর্জনের মাধ্যমে গড়ে তুলুন আপনার ভবিষ্যৎ',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: isMobile ? 14 : 18,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 32),

        //
        Material(
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              // Navigation logic here
              context.go('/courses');
            },
            child: Container(
              height: 40,
              width: 180,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: const Text(
                'কোর্স সমূহ দেখুন',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),

        //
      ],
    ),
  );
}

_buildImageBox(BuildContext context, {required bool isMobile}) {
  return Container(
    height: isMobile ? 250 : 450,
    color: Colors.black12.withValues(alpha: .05),
    child: Image.network(
      'https://static.vecteezy.com/system/resources/thumbnails/009/300/321/small_2x/3d-illustration-of-web-development-png.png',
      // fit: BoxFit.fitHeight,
    ),
  );
}

//
_buildCourseList() {
  final CourseController courseController = Get.put(CourseController());

  //
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 32),
      //
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'আমাদের কোর্স সমূহ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),

      const SizedBox(height: 16),

      //
      Obx(
        () {
          if (courseController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return SizedBox(
            height: 330,
            child: ScrollConfiguration(
              behavior: WebScrollBehavior(), // Enable mouse scrolling on web
              child: ListView.separated(
                // itemCount: courses.length,
                itemCount: courseController.courses.length,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 20),
                itemBuilder: (context, index) {
                  Course course = courseController.courses[index];

                  // Course course = courses[index];
                  //
                  return CourseCard(course: course);
                },
                separatorBuilder: (context, index) => const SizedBox(width: 24),
              ),
            ),
          );
        },
      ),
    ],
  );
}

_buildBenefitList() {
  List<Benefit> benefits = [
    Benefit(
      id: '1',
      imageUrl: 'live_class.png',
      title: 'লাইভ ক্লাস',
      subtitle: 'বিশেষজ্ঞ প্রশিক্ষকদের সাথে সরাসরি ইন্টারঅ্যাক্টিভ সেশন।',
    ),
    Benefit(
      id: '2',
      imageUrl: 'recorded_class.png',
      title: 'রেকর্ডেড ক্লাস',
      subtitle: 'স্বাচ্ছন্দ্যে প্রি-রেকর্ডেড সেশনগুলিতে প্রবেশ করুন।',
    ),
    Benefit(
      id: '3',
      imageUrl: 'contents.png',
      title: 'মানসম্মত কন্টেন্ট',
      subtitle: 'বর্তমান বাজার চাহিদা অনুযায়ী প্রস্তুতকৃত সিলেবাস।',
    ),
    Benefit(
      id: '4',
      imageUrl: 'mentor.png',
      title: 'মেন্টর সহায়তা',
      subtitle: 'অভিজ্ঞ মেন্টরদের কাছ থেকে পরামর্শ ও ফিডব্যাক।',
    ),
    Benefit(
      id: '5',
      imageUrl: 'assignemnt.png',
      title: 'প্রজেক্ট অ্যাসাইনমেন্ট',
      subtitle: 'বাস্তব জীবনের প্রজেক্টের সাথে হাতে-কলমে কাজের অভিজ্ঞতা।',
    ),
    Benefit(
      id: '6',
      imageUrl: 'freelancing.png',
      title: 'ফ্রিল্যান্সিং নির্দেশিকা',
      subtitle: 'সফল ফ্রিল্যান্সিংয়ের জন্য টিপস এবং কৌশল।',
    ),
    Benefit(
      id: '7',
      imageUrl: 'support.png',
      title: 'কমিউনিটি সাপোর্ট',
      subtitle: 'সহপাঠী ও শিক্ষার্থীদের সাথে সহযোগিতামূলক শিক্ষার সুযোগ।',
    ),
    Benefit(
      id: '8',
      imageUrl: 'assessment.png',
      title: 'অনলাইন মূল্যায়ন',
      subtitle: 'কোর্সে শেষে পরীক্ষার মাধ্যমে মূল্যায়নের সুযোগ।',
    ),
  ];

  //
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 32),
      //
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'কোর্সের সাথে যা যা পাচ্ছেন',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),

      const SizedBox(height: 16),

      //
      LayoutBuilder(
        builder: (context, constraints) {
          // Determine number of columns based on screen size
          int crossAxisCount = _getCrossAxisCount(constraints.maxWidth);

          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (var benefit in benefits)
                SizedBox(
                  width: (constraints.maxWidth - (crossAxisCount - 1) * 16) /
                      crossAxisCount,
                  child: BenefitCardGrid(benefit: benefit),
                ),
            ],
          );
        },
      ),
      //
    ],
  );
}

//
class BenefitCardGrid extends StatelessWidget {
  final Benefit benefit;

  const BenefitCardGrid({super.key, required this.benefit});

  @override
  Widget build(BuildContext context) {
    //
    return Container(
      constraints: const BoxConstraints(minHeight: 170),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      // width: 300,
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset(
                'assets/images/${benefit.imageUrl}',
                height: 50,
                width: 50,
              ),
            ),
            Text(
              benefit.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            // const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(minHeight: 56),
              padding: const EdgeInsets.all(8),
              child: Text(
                benefit.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
    return 2; // Extra Small Mobile (Portrait)
  }
}

double _adaptiveFontSize(BuildContext context, double baseFontSize) {
  // Base the scaling factor on the screen width
  double screenWidth = MediaQuery.of(context).size.width;

  // Define scaling factors for different screen sizes
  if (screenWidth < 480) {
    return baseFontSize * 0.7; // Smaller screens
  } else if (screenWidth < 600) {
    return baseFontSize * 0.9; // Small to medium screens
  } else if (screenWidth < 1200) {
    return baseFontSize; // Medium to large screens
  } else {
    return baseFontSize * 1.1; // Extra large screens
  }
}

class WebScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse, // Enables mouse drag for web
      };
}
