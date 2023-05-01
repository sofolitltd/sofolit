import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sofolit/screens/dashboard/assignments/assignment_details.dart';

import '/screens/dashboard/assignments/add_assignment.dart';
import '/utils/date_time_formatter.dart';

class Assignments extends StatelessWidget {
  const Assignments({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: kIsWeb
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddAssignment(uid: uid)));
              },
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AssignmentDetails(
                      data: data,
                      uid: uid,
                    )));
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
                    vertical: 2,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.yellow),
                  ),
                  child: const Icon(Icons.remove_red_eye_outlined)),
              title: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(data.get('title')),
              ),
              subtitle: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('courses')
                      .doc(uid)
                      .collection('assignment')
                      .doc(data.id)
                      .collection('subscribers')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                      );
                    }

                    if (!snapshot.hasData) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                      );
                    }

                    var status = 'Pending';
                    int? obtainMark;
                    if (snapshot.data!.exists) {
                      status = snapshot.data!.get('status');
                      obtainMark = snapshot.data!.get('marks');
                    }

                    return Row(
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
                                    : Colors.green.shade500,
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
                                color: Colors.white,
                              ),

                              const SizedBox(width: 4),

                              //
                              Text(
                                status,
                                style: const TextStyle(color: Colors.white),
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
                              color: Colors.deepPurpleAccent.shade200,
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
                                  '$obtainMark / ${data.get('marks')}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  }),
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
