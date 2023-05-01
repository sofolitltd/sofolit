import 'package:flutter/material.dart';

import '/screens/dashboard/assignments/assignments.dart';
import 'leaderboard/leaderboard.dart';
import 'recordings/recordings.dart';
import 'resources.dart';
import 'study/study_plan.dart';

class DashboardDetails extends StatelessWidget {
  const DashboardDetails({Key? key, required this.uid, required this.title})
      : super(key: key);

  final String uid;
  final String title;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: DefaultTabController(
        length: 5,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: !isSmallScreen ? size.width * .2 : 0),
          child: Column(
            children: [
              const SizedBox(height: 16),

              //
              Container(
                color: Colors.white,
                margin:
                    EdgeInsets.symmetric(horizontal: !isSmallScreen ? 16 : 0),
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
                    Assignments(uid: uid),
                    Leaderboard(uid: uid),
                    Recordings(uid: uid),
                    Resources(uid: uid),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
