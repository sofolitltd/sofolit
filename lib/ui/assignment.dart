import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Assignment extends StatelessWidget {
  const Assignment({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var ref = FirebaseFirestore.instance
              .collection('courses')
              .doc(uid)
              .collection('assignment');
          ref.doc().set({
            'title': 'What is figma ',
            'description': 'Learn about figma',
            'status': 'Pending',
            'marks': '',
            'time': DateTime.now(),
          });
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('courses')
              .doc(uid)
              .collection('assignment')
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
              shrinkWrap: true,
              itemCount: data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              itemBuilder: (context, index) {
                return AssignmentCard(data: data[index]);
              },
            );
          }),
    );
  }
}

class AssignmentCard extends StatelessWidget {
  const AssignmentCard({super.key, required this.data});

  final QueryDocumentSnapshot data;
  @override
  Widget build(BuildContext context) {
    return Card(
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
            child: Text(data.get('time').toDate().toString()),
          ),

          //
          ListTile(
            onTap: () {
              // context.goNamed('class', params: {'id': '${data + 1}'});
            },
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
            subtitle: Row(
              children: [
                // status
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.watch_later_outlined,
                        size: 16,
                      ),

                      const SizedBox(width: 4),

                      //
                      Text(data.get('status')),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // marks
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
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
                      const Icon(
                        Icons.calculate_outlined,
                        size: 16,
                      ),

                      const SizedBox(width: 4),

                      //
                      Text(data.get('marks')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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