import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sofolit/screens/courses/joining/joining.dart';

import '/screens/courses/assignments/assignments.dart';
import '/screens/courses/leaderboard/leaderboard.dart';
import '/screens/courses/modules/modules.dart';
import '/screens/courses/recordings/recordings.dart';
import '/screens/courses/resources/resources.dart';

class CoursesDetails extends StatelessWidget {
  const CoursesDetails({
    super.key,
    required this.uid,
    required this.title,
  });

  final String uid;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),

      //
      body: Column(
        children: [
          const SizedBox(height: 16),

          // current modules
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('courses')
                  .doc(uid)
                  .collection('modules')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var data = snapshot.data!.docs;
                if (data.isEmpty) {
                  return const Center(
                    child: Text('No modules found'),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }

                return Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //title
                      Row(
                        children: [
                          Text(
                            'Current Module',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //module
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  child: Text(
                                    'Module 22',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                  ),
                                ),

                                // date
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade400,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 1,
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    '18 April - 24 April',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            //2
                            Text(
                              'The ultimate freelancing guide',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

          const SizedBox(height: 16),

          // all
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              children: [
                //title
                Row(
                  children: [
                    Text(
                      'All Category',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 16),

                // category
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) {
                    return MaterialButton(
                      elevation: 0,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          switch (index) {
                            case 0:
                              return Modules(
                                courseID: uid,
                                title: categoryList[index]["title"],
                              );
                            case 1:
                              return Joining(
                                courseID: uid,
                                // title: categoryList[index]["title"],
                              );
                            case 2:
                              return Assignments(
                                uid: uid,
                                title: categoryList[index]["title"],
                              );
                            case 3:
                              return Recordings(
                                uid: uid,
                                title: categoryList[index]["title"],
                              );
                            case 4:
                              return Resources(
                                uid: uid,
                                title: categoryList[index]["title"],
                              );

                            default:
                              return Leaderboard(
                                uid: uid,
                                title: categoryList[index]["title"],
                              );
                          }
                        }));
                      },
                      color: Colors.white,
                      padding: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.blueGrey.shade100),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //

                          Icon(
                            categoryList[index]["image"],
                            size: 48,
                            color: categoryList[index]["color"],
                          ),

                          const SizedBox(height: 4),

                          //
                          Text(
                            categoryList[index]["title"],
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

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
