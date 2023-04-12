import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Courses extends StatelessWidget {
  const Courses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var ref = FirebaseFirestore.instance.collection('courses');
          ref.doc().set({
            'subtitle': 'UI/UX',
            'title': 'Figma Complete Course',
            'image': '',
          });
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('courses').snapshots(),
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
          var width = MediaQuery.of(context).size.width;
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Wrap(
                alignment:
                    width > 600 ? WrapAlignment.start : WrapAlignment.center,
                children: data
                    .map(
                      (data) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CourseCard(data: data),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  const CourseCard({Key? key, required this.data}) : super(key: key);

  final QueryDocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/dashboard/courses/${data.id}',
          extra: data.get('title'),
        );
      },
      child: Card(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
              ),

              //
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(data.get('subtitle'))),
                    const SizedBox(height: 8),
                    Text(
                      data.get('title'),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    //
                    context.push(
                      '/dashboard/courses/${data.id}',
                      extra: data.get('title'),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continue'.toUpperCase()),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
