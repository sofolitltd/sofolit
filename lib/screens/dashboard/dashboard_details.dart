import 'package:flutter/material.dart';
import 'package:sofolit/screens/dashboard/assignment/assignment.dart';
import 'package:sofolit/screens/leaderboard.dart';

import '../../ui/recording.dart';
import '../../ui/resource.dart';
import 'study/study_plan.dart';

class DashboardDetails extends StatelessWidget {
  const DashboardDetails({Key? key, required this.uid, required this.title})
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
                  Tab(text: 'Assignment'),
                  Tab(text: 'Leaderboard'),
                  Tab(text: 'Recording'),
                  Tab(text: 'Resource'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  StudyPlan(uid: uid),
                  Assignment(uid: uid),
                  Leaderboard(uid: uid),
                  Recording(uid: uid),
                  Resource(uid: uid),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
