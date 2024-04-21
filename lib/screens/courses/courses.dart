import 'package:flutter/material.dart';

import '/admin/admin_section.dart';
import '/screens/courses/widgets/my_courses.dart';

class Courses extends StatelessWidget {
  const Courses({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: Container(
        width: size.width,
        padding: EdgeInsets.symmetric(
            horizontal: !isSmallScreen ? size.width * .1 : 0),
        child: const SingleChildScrollView(
          child: Column(
            children: [
              //admin
              AdminSection(),

              //recent
              // RecentSection(),

              //my courses
              MyCourses(),
            ],
          ),
        ),
      ),
    );
  }
}
