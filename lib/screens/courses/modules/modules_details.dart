import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sofolit/admin/admin_button.dart';

import '../../../utils/date_time_formatter.dart';
import '/screens/courses/modules/video_player.dart';

class ModulesDetails extends StatelessWidget {
  const ModulesDetails({
    super.key,
    required this.courseID,
    required this.data,
  });

  final String courseID;
  final QueryDocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    DateTime startTime = data.get('startTime').toDate();
    DateTime finishTime = data.get('finishTime').toDate();

    return Scaffold(
      appBar: AppBar(
        title: Text('Module - ${data.get('moduleNo')}'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // 1
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //1

                  //2
                  Text(
                    data.get('moduleTitle'),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          // color: Colors.white,
                        ),
                  ),

                  Text(
                    DTFormatter.dateFull(startTime) +
                        "  -  " +
                        DTFormatter.dateFull(finishTime),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                  const SizedBox(height: 12),

                  //3
                  Row(
                    children: [
                      // class
                      Row(
                        children: [
                          //icon
                          const Icon(
                            Icons.video_call_outlined,
                            size: 18,
                          ),

                          const SizedBox(width: 4),

                          // label
                          Text(
                            '2 Live Class',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    // fontWeight: FontWeight.bold,
                                    // color: Colors.white,
                                    ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 24),

                      // assignment
                      Row(
                        children: [
                          //icon
                          const Icon(
                            Icons.assignment,
                            size: 14,
                          ),

                          const SizedBox(width: 4),

                          // label
                          Text(
                            '2 Assignment',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    // fontWeight: FontWeight.bold,
                                    // color: Colors.white,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Divider(height: 32),
                ],
              ),
            ),

            // 2
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,

                  indicator: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  // isScrollable: true,
                  tabs: [
                    Tab(text: 'Live Class'),
                    Tab(text: 'Assignment'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            //3
            Expanded(
              child: TabBarView(
                children: [
                  // 1
                  LiveClass(courseID: courseID, data: data),

                  // 2
                  const Center(child: Text('No Assignment Found!')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// live
class LiveClass extends StatefulWidget {
  const LiveClass({
    super.key,
    required this.courseID,
    required this.data,
  });
  final String courseID;
  final QueryDocumentSnapshot data;

  @override
  State<LiveClass> createState() => _LiveClassState();
}

class _LiveClassState extends State<LiveClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      floatingActionButton: AdminButton(onPressed: () {
        // FirebaseFirestore.instance
        //     .collection('courses')
        //     .doc(widget.courseID)
        //     .collection('lives')
        //     .doc()
        //     .set({
        //   'category': 'live',
        //   'title': 'Module 2 Live Class',
        //   'date': DateTime.now(),
        //   'videoURL': 'https://youtu.be/l-R2G83Ecw4',
        // });
      }),

      //
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .doc(widget.courseID)
            .collection('lives')
            // .where('category', isEqualTo: 'live')
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
              child: Text('No data found'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          return Scrollbar(
            child: ListView.separated(
              // physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //
                          const Icon(
                            Icons.check_circle_outline,
                            size: 32,
                            color: Colors.green,
                          ),

                          const SizedBox(width: 4),

                          //module
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 12),
                            child: Text(
                              'Live',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // date
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 1,
                              horizontal: 10,
                            ),
                            child: Text(
                              DTFormatter.dateFull(
                                  data[index].get('date').toDate()),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                            ),
                          ),
                        ],
                      ),

                      const Divider(),

                      //2
                      Text(
                        data[index].get('title'),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              // color: Colors.white,
                            ),
                      ),

                      const SizedBox(height: 10),

                      //3
                      MaterialButton(
                        onPressed: () {
                          var videoURL = data[index].get('videoURL');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VideoPlayer(
                                      data: data[index],
                                    )),
                          );
                        },
                        color: Colors.grey.shade200,
                        elevation: 0,
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //icon
                            const Icon(
                              Icons.play_circle_outlined,
                              // size: 14,
                            ),

                            const SizedBox(width: 8),

                            // label
                            Text(
                              'Class Recoding',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      // fontWeight: FontWeight.bold,
                                      // color: Colors.white,
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
