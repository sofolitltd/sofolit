import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../utils/date_time_formatter.dart';
import '../../../utils/open_app.dart';

class Recordings extends StatelessWidget {
  const Recordings({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: kIsWeb
          ? null
          : FloatingActionButton(
              onPressed: () {
                addRecording() {
                  var ref = FirebaseFirestore.instance
                      .collection('courses')
                      .doc(uid)
                      .collection('recoding');
                  ref.doc().set({
                    'class': 1,
                    'title': 'Class 2',
                    'description': 'Dm Tools',
                    'url':
                        'https://www.facebook.com/100003382574463/videos/pcb.1429073040965377/190784943724444',
                    'duration': '28 min',
                    'time': DateTime.now(),
                  });
                }
              },
            ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('courses')
              .doc(uid)
              .collection('recoding')
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
                return ClassRecordingsCard(data: data[index]);
              },
            );
          }),
    );
  }
}

class ClassRecordingsCard extends StatelessWidget {
  const ClassRecordingsCard({super.key, required this.data});

  final QueryDocumentSnapshot data;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: () {
          OpenApp.withUrl(data.get('url'));
        },
        trailing: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 2,
              horizontal: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.yellow.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.yellow),
            ),
            child: const Icon(
              Icons.play_arrow_outlined,
              color: Colors.black,
            )),
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.get('title'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                data.get('description'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(height: 1),
              ),
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            Row(
              children: [
                // duration
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 8,
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
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
                      Text(data.get('duration')),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // date
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 8,
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 16,
                      ),

                      const SizedBox(width: 4),

                      //
                      Text(DTFormatter.dateFormat(data.get('time'))),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
