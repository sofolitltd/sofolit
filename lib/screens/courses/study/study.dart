import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../modules/add_modules.dart';
import '/admin/admin_button.dart';
import 'components/study_card.dart';

class Study extends StatefulWidget {
  const Study({
    super.key,
    required this.moduleUid,
    required this.studyUid,
  });

  final String moduleUid;
  final String studyUid;

  @override
  State<Study> createState() => _StudyState();
}

class _StudyState extends State<Study> {
  bool isExpanded = false;
  int selectedTile = -1;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: AdminButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddModule(uid: widget.studyUid)));
        },
      ),
      // /courses/bkKDhGGG4bjWdOHGfBrn/modules/Sy1SqhfIBLAkhVYxVzQA/study
      appBar: AppBar(
        title: const Text("Modules"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('courses')
              .doc(widget.moduleUid)
              .collection('modules')
              .doc(widget.studyUid)
              .collection("study")
              .orderBy("class")
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
                return StudyCard(
                  data: data[index],
                  index: index,
                );
              },
            );
          }),
    );
  }
}
