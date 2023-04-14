import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sofolit/screens/home/widgets/home_courses.dart';

import '../dashboard_details.dart';

class DashboardCourse extends StatelessWidget {
  const DashboardCourse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('courses').where(
          'subscribers',
          arrayContainsAny: [FirebaseAuth.instance.currentUser!.uid],
        ).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 400,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return Container(
              height: 400,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }

          var data = snapshot.data!.docs;
          if (data.isEmpty) {
            return const HomeCourses();
          }

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Theme.of(context).cardColor,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //head
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Text(
                    'My Courses',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),

                //
                SizedBox(
                  height: 260,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.grey,
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return CourseCard(data: data[index]);
                    },
                  ),
                ),

                //
              ],
            ),
          );
        });
  }
}

//card
class CourseCard extends StatelessWidget {
  const CourseCard({Key? key, required this.data}) : super(key: key);

  final QueryDocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardDetails(
              uid: data.id,
              title: data.get('title'),
            ),
          ),
        );
      },
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).dividerColor, width: .5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              Container(
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      data.get('image'),
                    ),
                  ),
                  color: Colors.blue.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
              ),

              //batch
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
                      child: Text(
                        data.get('batch'),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    //title
                    Text(
                      data.get('title'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
