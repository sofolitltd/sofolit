import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/screens/courses/modules/assignment/assignment.dart';
import '/utils/date_time_formatter.dart';
import 'class/class.dart';
import 'modules.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;

    DateTime startTime = data.get('startTime').toDate();
    DateTime finishTime = data.get('finishTime').toDate();
    DateTime now = DateTime.now();

    String status = '';
    IconData statusIcon = Icons.error;
    Color statusColor = Colors.grey;
    bool isOngoing = false;

    if (now.isBefore(startTime)) {
      status = StatusEnum.upcoming.name;
      statusIcon = Icons.schedule;
      statusColor = Colors.red;
    } else if (now.isAfter(finishTime)) {
      status = StatusEnum.completed.name;
      statusIcon = Icons.check_circle_outline;
      statusColor = Colors.green;
    } else {
      status = StatusEnum.ongoing.name;
      statusIcon = Icons.play_circle_outline;
      statusColor = Colors.yellow;
      isOngoing = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Module - ${data.get('moduleNo')}'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1080),
            padding:
                EdgeInsets.symmetric(horizontal: screenWidth > 600 ? 32 : 0),
            child: Column(
              children: [
                // 1
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //2
                      Text(
                        data.get('moduleTitle'),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 22,
                              // color: Colors.white,
                            ),
                      ),

                      const SizedBox(height: 8),

                      // date
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //status
                          Container(
                            decoration: BoxDecoration(
                                color: isOngoing ? Colors.black : Colors.white,
                                borderRadius: BorderRadius.circular(4)),
                            padding: const EdgeInsets.fromLTRB(10, 4, 12, 4),
                            child: Row(
                              children: [
                                Icon(
                                  statusIcon,
                                  size: 14,
                                  color: statusColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  status.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: statusColor,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 16),

                          // date range
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 12,
                            ),
                            child: Text(
                              DTFormatter.dateFull(startTime) +
                                  " - " +
                                  DTFormatter.dateFull(finishTime),
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

                      const SizedBox(height: 8),

                      //3
                      Row(
                        children: [
                          // todo: separate class later
                          SizedBox(
                            width: 100,
                            height: 24,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('courses')
                                  .doc(courseID)
                                  .collection('classes')
                                  .where('moduleNo',
                                      isEqualTo: data.get('moduleNo'))
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox();
                                }
                                var data = snapshot.data!.docs;
                                if (data.isEmpty) {
                                  return const SizedBox();
                                }
                                if (!snapshot.hasData) {
                                  return const SizedBox();
                                }

                                return Row(
                                  children: [
                                    //icon
                                    const Icon(
                                      Icons.video_call_outlined,
                                      size: 20,
                                      color: Colors.red,
                                    ),

                                    const SizedBox(width: 6),

                                    // label
                                    Text(
                                      '${data.length}  Live Class',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey,
                                          ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                          const SizedBox(width: 24),

                          // assignment
                          SizedBox(
                            width: 120,
                            height: 24,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('courses')
                                  .doc(courseID)
                                  .collection('assignments')
                                  .where('moduleNo',
                                      isEqualTo: data.get('moduleNo'))
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox();
                                }
                                var data = snapshot.data!.docs;
                                if (data.isEmpty) {
                                  return const SizedBox();
                                }
                                if (!snapshot.hasData) {
                                  return const SizedBox();
                                }

                                return Row(
                                  children: [
                                    //icon
                                    const Icon(
                                      Icons.assignment_outlined,
                                      size: 18,
                                      color: Colors.teal,
                                    ),

                                    const SizedBox(width: 6),

                                    // label
                                    Text(
                                      '${data.length} Assignment',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey,
                                          ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      const Divider(height: 10),
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

                const SizedBox(height: 10),

                //3
                Expanded(
                  child: TabBarView(
                    children: [
                      // 1
                      Class(
                        courseID: courseID,
                        classData: data,
                        moduleStatus: status,
                      ),

                      // 2
                      Assignment(
                        courseID: courseID,
                        classData: data,
                        moduleStatus: status,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
