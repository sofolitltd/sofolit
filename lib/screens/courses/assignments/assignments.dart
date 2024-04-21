import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/admin/admin_button.dart';
import '/screens/courses/assignments/add_assignment.dart';
import '/screens/courses/assignments/assignment_details.dart';
import '/utils/date_time_formatter.dart';

class Assignments extends StatelessWidget {
  const Assignments({
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
              MaterialPageRoute(builder: (context) => AddAssignment(uid: uid)));
        },
      ),
      appBar: AppBar(
        title: Text(title),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('courses')
              .doc(uid)
              .collection('assignment')
              .orderBy('title')
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

            return ListView.separated(
              // shrinkWrap: true,
              itemCount: data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              itemBuilder: (context, index) {
                return AssignmentCard(data: data[index], uid: uid);
              },
            );
          }),
    );
  }
}

class AssignmentCard extends StatelessWidget {
  const AssignmentCard({super.key, required this.data, required this.uid});

  final String uid;
  final QueryDocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    String status = 'Pending';
    String feedback = '';
    int obtainMark = 0;
    int totalMark = 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssignmentDetails(
              data: data,
              uid: uid,
              status: status,
              obtainMark: obtainMark,
              totalMark: totalMark,
              feedback: feedback,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 0, 0),
              child: Row(
                children: [
                  const Text(
                    'Deadline: ',
                    style: TextStyle(color: Colors.red),
                  ),
                  Text(DTFormatter.dateTimeFormat(data.get('time'))),
                ],
              ),
            ),

            //
            ListTile(
              trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.yellow),
                  ),
                  child: const Icon(Icons.remove_red_eye_outlined)),
              title: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(data.get('title')),
              ),
              subtitle: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('courses')
                    .doc(uid)
                    .collection('assignments')
                    .where('assignmentId', isEqualTo: data.id)
                    .where('uid',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(height: 44);
                  }

                  if (!snapshot.hasData) {
                    return const SizedBox(height: 44);
                  }

                  for (var doc in snapshot.data!.docs) {
                    if (doc.exists) {
                      status = doc.get('status');
                      obtainMark = doc.get('obtainMark');
                      totalMark = doc.get('totalMark');
                      feedback = doc.get('feedback');
                    }
                  }

                  return SizedBox(
                    height: 44,
                    child: Row(
                      children: [
                        // status
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 8,
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: status == 'Pending'
                                ? Colors.orange.shade500
                                : status == 'Submitted'
                                    ? Colors.blue.shade500
                                    : null,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                status == 'Pending'
                                    ? Icons.watch_later_outlined
                                    : status == 'Submitted'
                                        ? Icons.upload_file_outlined
                                        : Icons.fact_check_outlined,
                                size: 16,
                                color: (status == 'Pending' ||
                                        status == 'Submitted')
                                    ? Colors.white
                                    : Colors.green,
                              ),

                              const SizedBox(width: 4),

                              //
                              Text(
                                status,
                                style: TextStyle(
                                  color: (status == 'Pending' ||
                                          status == 'Submitted')
                                      ? Colors.white
                                      : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // marks
                        if (status == 'Approved')
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 8,
                            ),
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Marks:',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(width: 4),

                                //
                                Text(
                                  '$obtainMark / $totalMark',
                                  style: const TextStyle(
                                    color: Colors.white,
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
            ),
          ],
        ),
      ),
    );
  }
}

// todo: ClassRecordingDetails
// class ClassRecordingDetails extends StatelessWidget {
//   const ClassRecordingDetails({Key? key, this.id}) : super(key: key);
//   final String? id;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               height: 200,
//               color: Colors.blue.shade50,
//             ),
//
//             const SizedBox(height: 16),
//             //
//             Expanded(
//               child: ListView.separated(
//                 shrinkWrap: true,
//                 itemCount: 15,
//                 separatorBuilder: (_, __) => const SizedBox(height: 16),
//                 padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                 itemBuilder: (context, index) {
//                   return ClassRecordingsCard(data: index);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
