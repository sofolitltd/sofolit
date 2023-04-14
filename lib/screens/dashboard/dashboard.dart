import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sofolit/screens/dashboard/widgets/dashboard_course.dart';
import 'package:sofolit/screens/dashboard/widgets/recent_section.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      floatingActionButton: kIsWeb
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                var ref = FirebaseFirestore.instance.collection('courses');
                ref.doc().set({
                  'title': 'Digital Marketing Complete Course',
                  'subtitle': 'Digital Marketing 1',
                  'description': 'Learn Digital Marketing',
                  'image':
                      'https://designshack.net/wp-content/uploads/placeholder-image.png',
                  'price': 1000,
                  'discount': 10,
                  'seat': 30,
                  'startDate': DateTime.now(),
                  'lastDate': DateTime.now(),
                  'classTime': '10:00 pm - 11:00 PM',
                  'classDay': 'Sun, Tue',
                  'subscribers': [],
                });
              },
            ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: const [
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
