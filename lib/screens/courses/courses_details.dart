import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../admin/admin_button.dart';
import '../check_assignments.dart';
import '/screens/courses/assignments/assignments.dart';
import '/screens/courses/joining/joining.dart';
import '/screens/courses/leaderboard/leaderboard.dart';
import '/screens/courses/modules/modules.dart';
import '/screens/courses/recordings/recordings.dart';
import '/screens/courses/resources/resources.dart';

class CoursesDetails extends StatelessWidget {
  const CoursesDetails({
    super.key,
    required this.courseID,
    required this.title,
  });

  final String courseID;
  final String title;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: screenWidth > 600 ? Colors.white : Colors.transparent,
        automaticallyImplyLeading: false,
        title: screenWidth > 600 ? Text(title) : const Text(''),
        leading: BackButton(
          color: screenWidth > 600 ? Colors.black : Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: screenWidth > 600 ? 88 : 0),
            constraints:
                const BoxConstraints(maxWidth: 1080), // Set maximum width here
            child: Column(
              children: [
                //
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('courses')
                      .doc(courseID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var course = snapshot.data!;

                    if (!course.exists) {
                      return const Center(
                        child: Text('No course found'),
                      );
                    }

                    return Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: screenWidth > 600
                          ? Row(
                              children: [
                                Container(
                                  height: 200,
                                  width: 400,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        course.get('courseImage'),
                                      ),
                                    ),
                                    color: Colors.blue.shade100,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          course.get('courseTitle'),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                height: 1.3,
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 2,
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.deepOrange.shade400,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            '${course.get('courseBatch')} ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_month_rounded,
                                              size: 16,
                                              color: Colors.deepOrange.shade400,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              ' Class Days:',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: (course.get('classSchedule')
                                                  as List<dynamic>)
                                              .map<Widget>((classSchedule) {
                                            return Text(
                                              classSchedule.toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        course.get('courseImage'),
                                      ),
                                    ),
                                    color: Colors.blue.shade100,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.get('courseTitle'),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              height: 1.3,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.deepOrange.shade400,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          '${course.get('courseBatch')} ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month_rounded,
                                            size: 16,
                                            color: Colors.deepOrange.shade400,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            ' Class Days:',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: (course.get('classSchedule')
                                                as List<dynamic>)
                                            .map<Widget>((classSchedule) {
                                          return Text(
                                            classSchedule.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    );
                  },
                ),

                // explore
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth > 600 ? 32 : 16,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenWidth > 600 ? 8 : 0),

                      //
                      Text(
                        'Explore',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      SizedBox(height: screenWidth > 600 ? 32 : 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 16,
                          crossAxisCount: screenWidth > 700 ? 6 : 3,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: categoryList.length,
                        itemBuilder: (_, index) {
                          return CategoryCard(
                            index: index,
                            courseID: courseID,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // check assignment
                AdminButton(
                  onPressed: () {},
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Admin'),
                        const SizedBox(height: 16),
                        //
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CheckAssignment(
                                            courseID: courseID,
                                          )));
                            },
                            child: const Text('Check Assignments')),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.index,
    required this.courseID,
  });

  final int index;
  final String courseID;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            switch (index) {
              case 0:
                return Modules(
                  courseID: courseID,
                  title: categoryList[index]["title"],
                );
              case 1:
                return Joining(
                  courseID: courseID,
                );
              case 2:
                return Assignments(
                  courseID: courseID,
                );
              case 3:
                return Recordings(
                  uid: courseID,
                  title: categoryList[index]["title"],
                );
              case 4:
                return Resources(
                  uid: courseID,
                  title: categoryList[index]["title"],
                );
              default:
                return Leaderboard(
                  uid: courseID,
                  title: categoryList[index]["title"],
                );
            }
          }),
        );
      },
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            categoryList[index]["image"],
            size: 48,
            color: categoryList[index]["color"],
          ),
          const SizedBox(height: 4),
          Text(
            categoryList[index]["title"],
            style: Theme.of(context).textTheme.subtitle1!.copyWith(),
          ),
        ],
      ),
    );
  }
}

//
List categoryList = [
  {
    "title": "Modules",
    "image": Icons.file_open_outlined,
    "color": Colors.green.shade200,
  },
  {
    "title": "Joining",
    "image": Icons.video_camera_front_outlined,
    "color": Colors.red.shade200,
  },
  {
    "title": "Assignments",
    "image": Icons.settings_applications_outlined,
    "color": Colors.blue.shade200,
  },
  {
    "title": "Recordings",
    "image": Icons.perm_media_outlined,
    "color": Colors.amber.shade200,
  },
  {
    "title": "Resources",
    "image": Icons.source_outlined,
    "color": Colors.pink.shade200,
  },
  {
    "title": "Leaderboard",
    "image": Icons.leaderboard_outlined,
    "color": Colors.purple.shade200,
  },
];
