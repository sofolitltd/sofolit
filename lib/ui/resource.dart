import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Resource extends StatelessWidget {
  const Resource({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: kIsWeb
          ? null
          : FloatingActionButton(
              onPressed: () {
                var ref = FirebaseFirestore.instance
                    .collection('courses')
                    .doc(uid)
                    .collection('resource');
                ref.doc().set({
                  'title': 'Figma ',
                  'description': 'Learn about figma',
                  'resource': '',
                  'time': DateTime.now(),
                });
              },
            ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('courses')
              .doc(uid)
              .collection('resource')
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
                return Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  child: ListTile(
                    title: Text(data[index].get('title')),
                    subtitle: Text(data[index].get('time').toDate().toString()),
                    trailing: ElevatedButton.icon(
                      icon: const Icon(Icons.link_rounded),
                      onPressed: () {},
                      label: const Text('Browse'),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
