import 'package:flutter/material.dart';
import 'package:sofolit/screens/admin/admin_button.dart';

import '/screens/dashboard/widgets/dashboard_course.dart';
import '/screens/dashboard/widgets/recent_section.dart';
import '../admin/admin_section.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      floatingActionButton: AdminButton(
        onPressed: () {
          // var ref = FirebaseFirestore.instance.collection('courses');
          // ref.doc().set({
          //   'title': 'Digital Marketing Complete Course',
          //   'subtitle': 'Digital Marketing 1',
          //   'description': 'Learn Digital Marketing',
          //   'image':
          //       'https://designshack.net/wp-content/uploads/placeholder-image.png',
          //   'price': 1000,
          //   'discount': 10,
          //   'seat': 30,
          //   'startDate': DateTime.now(),
          //   'lastDate': DateTime.now(),
          //   'classTime': '10:00 pm - 11:00 PM',
          //   'classDay': 'Sun, Tue',
          //   'subscribers': [],
          // });
        },
      ),
      body: Container(
        width: size.width,
        padding: EdgeInsets.symmetric(
            horizontal: !isSmallScreen ? size.width * .1 : 0),
        child: SingleChildScrollView(
          child: Column(
            children: const [
              //admin
              AdminSection(),

              //recent
              RecentSection(),

              // courses
              DashboardCourse(),
            ],
          ),
        ),
      ),
    );
  }
}
