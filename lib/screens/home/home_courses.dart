import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/course_model.dart';
import 'home_details.dart';

class HomeCourses extends StatelessWidget {
  const HomeCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .limit(8)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 350,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return Container(
              height: 350,
              alignment: Alignment.center,
              child: const Text('Something went wrong'),
            );
          }
          var data = snapshot.data!.docs;
          // List students = [];
          // for (var element in data) {
          //   students = element.get('enrolledStudents');
          // }
          // if (students.contains(FirebaseAuth.instance.currentUser!.uid)) {
          //   return const SizedBox();
          // }

          if (data.isEmpty) {
            return Container(
              height: 350,
              alignment: Alignment.center,
              child: const Text('No courses found'),
            );
          }

          return Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //head
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Text(
                        'Live Courses',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),

                    // todo:
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 8),
                    //   child: TextButton(
                    //       onPressed: () {}, child: const Text('See more')),
                    // ),
                  ],
                ),

                //
                SizedBox(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.grey,
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      List students = data[index].get('enrolledStudents');
                      if (students
                          .contains(FirebaseAuth.instance.currentUser!.uid)) {
                        return const SizedBox();
                      }
                      return const SizedBox(width: 20);
                    },
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      //
                      List students = data[index].get('enrolledStudents');
                      if (students
                          .contains(FirebaseAuth.instance.currentUser!.uid)) {
                        return const SizedBox();
                      }

                      CourseModel course = CourseModel.fromJson(data[index]);
                      return CourseCard(course: course);
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
  const CourseCard({super.key, required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    int remainingDays =
        course.enrollFinish.difference(course.enrollStart).inDays;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeDetails(course: course),
          ),
        );
      },
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black54, width: .5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          width: 260,
          child: Column(
            children: [
              //
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  //image
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          course.courseImage,
                        ),
                      ),
                      color: Colors.blue.shade100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                  ),

                  //
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${course.discountRate}% ',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          'off',
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              //sub and tile
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //sub and title
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //batch
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  course.courseBatch,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              //remaining
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.watch_later_outlined,
                                    size: 18,
                                  ),

                                  const SizedBox(width: 4),
                                  //
                                  Text(
                                    remainingDays == 0
                                        ? 'On Going'
                                        : '$remainingDays days remaining',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: remainingDays == 0
                                              ? Colors.red
                                              : null,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          //title
                          Text(
                            course.courseTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                  // fontSize: 18,
                                ),
                          ),
                        ],
                      ),

                      // price & seat
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //price
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              //discount
                              Text(
                                '৳ ${course.coursePrice}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.deepOrange.shade400,
                                      height: 1.3,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                              ),

                              const SizedBox(width: 8),

                              //price
                              Text(
                                '৳ ${course.coursePrice - (course.coursePrice * (course.discountRate / 100)).round()}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      height: 1.3,
                                    ),
                              ),
                            ],
                          ),

                          //seat
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.people_outline,
                                size: 20,
                              ),

                              const SizedBox(width: 8),
                              //
                              Text(
                                '${course.courseSeats - course.enrolledStudents.length} seats left',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(),
                              ),
                            ],
                          ),
                        ],
                      ),
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
