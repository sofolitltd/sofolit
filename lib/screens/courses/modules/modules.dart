import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/admin/admin_button.dart';
import '/utils/date_time_formatter.dart';
import 'add_modules.dart';
import 'modules_details.dart';

class Modules extends StatelessWidget {
  const Modules({
    super.key,
    required this.uid,
    required this.title,
  });

  final String uid;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AdminButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddModule(uid: uid)));
        },
      ),
      appBar: AppBar(
        title: Text(title),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .doc(uid)
            .collection('modules')
            .orderBy('moduleNo')
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
              separatorBuilder: (context, index) => const SizedBox(height: 24),
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              itemBuilder: (context, index) {
                DateTime startTime = data[index].get('startTime').toDate();
                DateTime finishTime = data[index].get('finishTime').toDate();
                DateTime now = DateTime.now();

                String status = '';
                IconData statusIcon = Icons.error;
                Color statusColor = Colors.grey;
                bool isOngoing = false;

                if (now.isBefore(startTime)) {
                  status = 'Upcoming';
                  statusIcon = Icons.schedule;
                  statusColor = Colors.red;
                } else if (now.isAfter(finishTime)) {
                  status = 'Completed';
                  statusIcon = Icons.check_circle_outline;
                  statusColor = Colors.green;
                } else {
                  status = 'Ongoing';
                  statusIcon = Icons.play_circle_outline;
                  statusColor = Colors.yellow;
                  isOngoing = true;
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModulesDetails(
                          data: data[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: isOngoing ? Colors.black : Colors.white,
                        // : statusColor.withOpacity(.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade400,
                        )),
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(.7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Text(
                                'Module - ${data[index].get('moduleNo')} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 10,
                              ),
                              child: Text(
                                DTFormatter.date(startTime) +
                                    " - " +
                                    DTFormatter.date(finishTime),
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
                        Text(
                          data[index].get('moduleTitle'),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: isOngoing ? Colors.white : Colors.black,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.video_call_outlined,
                                  size: 18,
                                  color:
                                      isOngoing ? Colors.white : Colors.black,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '2 Live Class',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: isOngoing
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 24),
                            Row(
                              children: [
                                Icon(
                                  Icons.assignment,
                                  size: 14,
                                  color:
                                      isOngoing ? Colors.white : Colors.black,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '2 Assignment',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: isOngoing
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
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
                            Icon(
                              Icons.keyboard_arrow_right_outlined,
                              size: 20,
                              color: isOngoing ? Colors.white : Colors.black,
                            ),
                          ],
                        ),
                      ],
                    ),
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

//
// return GridView.builder(
// shrinkWrap: true,
// gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// crossAxisCount: width > 1000 ? 2 : 1,
// mainAxisSpacing: 16,
// crossAxisSpacing: 16,
// childAspectRatio: 2.2,
// ),
// itemCount: data.length,
// padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
// itemBuilder: (context, index) {
// return InkWell(
// onTap: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => Study(
// studyUid: data[index].id,
// moduleUid: widget.uid,
// ),
// ));
// },
// child: Container(
// padding: const EdgeInsets.all(16),
// decoration: BoxDecoration(
// border: Border.all(
// color: Colors.blueGrey.shade100,
// width: 2,
// ),
// borderRadius: BorderRadius.circular(8),
// color: Colors.white,
// ),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Container(
// padding:
// const EdgeInsets.symmetric(horizontal: 12),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(4),
// color: Colors.green.shade400,
// ),
// child: Text.rich(
// TextSpan(
// text: "Module ",
// style: const TextStyle(
// fontWeight: FontWeight.w600,
// fontSize: 18,
// ),
// children: [
// TextSpan(
// text: "${data[index].get('module')}",
// style: const TextStyle(
// fontWeight: FontWeight.bold,
// fontSize: 24,
// height: 1.5,
// ),
// ),
// ],
// ),
// ),
// ),
// const SizedBox(width: 16),
// Container(
// padding: const EdgeInsets.symmetric(
// vertical: 4, horizontal: 10),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(4),
// color: Colors.grey.shade200,
// ),
// child: Text(
// "${data[index].get('time')}",
// style: const TextStyle(
// fontWeight: FontWeight.w500,
// fontSize: 14,
// ),
// ),
// ),
// ],
// ),
//
// //
// const Divider(thickness: 2, height: 20),
//
// //
// const Text(
// "Dart programing",
// style: TextStyle(
// fontWeight: FontWeight.bold,
// fontSize: 24,
// height: 1.2,
// ),
// ),
//
// const SizedBox(height: 10),
//
// //
// const Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Row(
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// Icon(
// Icons.video_camera_front_outlined,
// size: 18,
// ),
// SizedBox(width: 6),
// Text(
// "2 Live class",
// style: TextStyle(
// fontWeight: FontWeight.w500,
// fontSize: 16,
// ),
// ),
// ],
// ),
// Row(
// children: [
// Icon(
// Icons.assessment_outlined,
// size: 20,
// ),
// SizedBox(width: 6),
// Text(
// "2 Assignment",
// style: TextStyle(
// fontWeight: FontWeight.w500,
// fontSize: 16,
// ),
// ),
// ],
// ),
// Row(
// children: [
// Icon(
// Icons.account_balance_wallet_outlined,
// size: 20,
// ),
// SizedBox(width: 6),
// Text(
// "2 Test",
// style: TextStyle(
// fontWeight: FontWeight.w500,
// fontSize: 16,
// ),
// ),
// ],
// ),
// ],
// ),
// ],
// ),
// ),
// );
// return StudyCard(
// data: data[index],
// index: index,
// );
// },
// );