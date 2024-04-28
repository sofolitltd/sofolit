import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({
    super.key,
    required this.courseID,
    required this.title,
  });

  final String courseID;
  final String title;

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _calculateAllAverageObtainMarks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          var data = snapshot.data!;
          if (data.isEmpty) {
            return const Center(
              child: Text('No data found'),
            );
          }

          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1080),
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 600 ? 32 : 16,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Leaderboard',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const Divider(height: 2),
                  ListView.separated(
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    shrinkWrap: true,
                    itemCount: data.length,
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
                    itemBuilder: (context, index) {
                      var docData = data[index];
                      var averageObtainMark =
                          docData['averageObtainMark'] ?? 0.0;
                      var documentId = docData['documentId'];
                      return _buildListItem(
                          documentId, averageObtainMark, index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _calculateAllAverageObtainMarks() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.courseID)
        .collection('leaderboard')
        .get();
    var data = <Map<String, dynamic>>[];
    for (var doc in snapshot.docs) {
      var documentId = doc.id;
      var assignmentsRef = doc.reference.collection('assignments');
      var assignmentQuerySnapshot = await assignmentsRef.get();
      int totalObtainMark = 0;
      int totalAssignments = 0;
      for (var assignmentDoc in assignmentQuerySnapshot.docs) {
        int obtainMark = assignmentDoc.get('obtainMark') ?? 0;
        totalObtainMark += obtainMark;
        totalAssignments++;
      }
      double averageObtainMark =
          totalAssignments > 0 ? totalObtainMark / totalAssignments : 0;
      data.add(
          {'documentId': documentId, 'averageObtainMark': averageObtainMark});
    }

    // Sort the data based on average obtain mark in descending order
    data.sort(
        (a, b) => b['averageObtainMark'].compareTo(a['averageObtainMark']));

    return data;
  }

  Widget _buildListItem(
      String documentId, double averageObtainMark, int index) {
    var uid = FirebaseAuth.instance.currentUser!.uid;

    return Container(
      color: documentId == uid
          ? Colors.yellow.shade200
          : Theme.of(context).cardColor,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minLeadingWidth: 0,
        leading: Text(
          '${index + 1}',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(documentId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(),
              );
            }
            var data = snapshot.data!;
            if (!data.exists) {
              return const Center(
                child: Text('No data found'),
              );
            }
            return Text(data.get('name'));
          },
        ),
        trailing: FittedBox(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  averageObtainMark.toStringAsFixed(0),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'points',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
