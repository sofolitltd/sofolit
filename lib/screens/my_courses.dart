import 'package:flutter/material.dart';
import 'package:sofolit/ui/recording.dart';
import 'package:sofolit/ui/resource.dart';

import '../ui/study_plan.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({Key? key}) : super(key: key);

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  int _selectedMenu = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI/UI Design with Figma'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tab bar

          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 40,
              color: Colors.white,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: menu.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _selectedMenu = index;
                        setState(() {});
                      },
                      child: SizedBox(
                        width: 125,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child:
                                  Flexible(child: Text(menu.elementAt(index))),
                            ),
                            _selectedMenu == index
                                ? Container(
                                    height: 2,
                                    color: Colors.yellow,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),

          Expanded(child: menuItems.elementAt(_selectedMenu)),
        ],
      ),
    );
  }
}

card(title) => InkWell(
      onTap: () {},
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(title),
          ),
          Container(
            height: 2,
            width: 120,
            color: Colors.yellow,
          ),
        ],
      ),
    );

List<String> menu = [
  'Study Plan',
  'Class Recording',
  'Resource',
];

List menuItems = [
  const StudyPlan(),
  const Recording(),
  const Resource(),
];
