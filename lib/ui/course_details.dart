import 'package:flutter/material.dart';
import 'package:sofolit/ui/assignment.dart';
import 'package:sofolit/ui/leaderboard.dart';

import 'recording.dart';
import 'resource.dart';
import 'study_plan.dart';

class CourseDetails extends StatelessWidget {
  const CourseDetails({Key? key, required this.uid, required this.title})
      : super(key: key);

  final String uid;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: DefaultTabController(
        length: 5,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              margin: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: const TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                isScrollable: true,
                tabs: [
                  Tab(text: 'Study Plan'),
                  Tab(text: 'Recording'),
                  Tab(text: 'Assignment'),
                  Tab(text: 'Resource'),
                  Tab(text: 'Leaderboard'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  StudyPlan(uid: uid),
                  Recording(uid: uid),
                  Assignment(uid: uid),
                  Resource(uid: uid),
                  Leaderboard(uid: uid),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
