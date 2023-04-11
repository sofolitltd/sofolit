import 'package:flutter/material.dart';
import 'package:sofolit/ui/assignment.dart';
import 'package:sofolit/ui/leaderboard.dart';

import 'recording.dart';
import 'resource.dart';
import 'study_plan.dart';

class Figma extends StatelessWidget {
  const Figma({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Figma'),
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
            const Expanded(
              child: TabBarView(
                children: [
                  StudyPlan(),
                  Recording(),
                  Assignment(),
                  Resource(),
                  Leaderboard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
