import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudyPlan extends StatelessWidget {
  const StudyPlan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var ref = FirebaseFirestore.instance
              .collection('courses')
              .doc('vy3n4NmgSFh3aLNenv5w')
              .collection('study');
          ref.doc().set({
            'class': 1,
            'title': 'What is figma ',
            'description': 'Learn about figma',
            'meeting': '',
            'resource': '',
            'recording': '',
            'time': DateTime.now(),
          });
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('courses')
              .doc('vy3n4NmgSFh3aLNenv5w')
              .collection('study')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('No data found'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var data = snapshot.data!.docs;
            var width = MediaQuery.of(context).size.width;

            return ListView.separated(
              shrinkWrap: true,
              itemCount: data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              itemBuilder: (context, index) {
                Timestamp time = data[index].get('time');

                return Theme(
                  data: ThemeData().copyWith(dividerColor: Colors.transparent),
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ExpansionTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                            'Day ${data[index].get('class')} ${data[index].get('title')}'),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              size: 16,
                            ),

                            const SizedBox(width: 8),

                            //
                            Text(time.toDate().toString()),
                          ],
                        ),
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Theme(
                                data: ThemeData()
                                    .copyWith(dividerColor: Colors.grey),
                                child: const Divider(height: 2)),
                            const SizedBox(height: 10),
                            Text(
                              '${data[index].get('description')}',
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                if (data[index].get('class') != '')
                                  ElevatedButton.icon(
                                      icon:
                                          const Icon(Icons.video_call_outlined),
                                      onPressed: () {},
                                      label: const Text('Live Class')),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
