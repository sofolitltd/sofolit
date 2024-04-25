import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../utils/date_time_formatter.dart';
import '../modules/video_player_web.dart';

class Recordings extends StatelessWidget {
  const Recordings({
    super.key,
    required this.uid,
    required this.title,
  });

  final String uid;
  final String title;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Recording'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .doc(uid)
            .collection('classes')
            .orderBy('moduleNo', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No data found'),
            );
          }

          var data = snapshot.data!.docs;

          var classRecordings =
              data.where((doc) => doc.get('classVideo')[0] != '').toList();

          if (classRecordings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons
                        .hourglass_empty, // You can change the icon as per your preference
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Currently, there are no available\nClass Recordings!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back later for updates.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            );
          }

          return Scrollbar(
            child: ListView.separated(
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemCount: classRecordings.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                return Center(
                  child: Container(
                      // color: Colors.white,
                      constraints: const BoxConstraints(maxWidth: 1080),
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth > 600 ? 32 : 0),
                      child: ClassRecordingsCard(data: classRecordings[index])),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ClassRecordingsCard extends StatelessWidget {
  const ClassRecordingsCard({super.key, required this.data});

  final QueryDocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // play page
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => VideoPlayer(data: data)));
      },
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //1
              Row(
                children: [
                  //
                  Container(
                    // width: 94,
                    decoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.fromLTRB(8, 8, 9, 3),
                    child: Text(
                      'Module  ${data.get('moduleNo')}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  //
                  Container(
                    // width: 74,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.fromLTRB(8, 8, 9, 3),
                    child: Text(
                      'Class  ${data.get('classNo')}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                    ),
                  ),

                  const Spacer(),
                  //
                  const Icon(
                    Icons.play_circle,
                    color: Colors.black54,
                    size: 24,
                  ),
                ],
              ),

              const Divider(height: 24),

              // 2
              Text(
                data.get('classTitle'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 3),

              // date
              Row(
                children: [
                  const Icon(Icons.calendar_month_outlined, size: 14),

                  const SizedBox(width: 8),

                  //
                  Text(
                    DTFormatter.dateWithDay(data.get('classDate').toDate()),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
