import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:sofolit/screens/courses/modules/assignment/assignment_add.dart';
import 'package:sofolit/screens/courses/modules/assignment/assignment_submit.dart';

import '../modules.dart';
import '/admin/admin_button.dart';
import '/utils/date_time_formatter.dart';

class Assignment extends StatefulWidget {
  const Assignment({
    super.key,
    required this.courseID,
    required this.classData,
    required this.moduleStatus,
  });

  final String courseID;
  final QueryDocumentSnapshot classData;
  final String moduleStatus;

  @override
  State<Assignment> createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      floatingActionButton: AdminButton(onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAssignment(
                courseID: widget.courseID,
                moduleNo: widget.classData.get('moduleNo'),
                classNo: 10,
                classTitle: 'Assignment',
                classDate: DateTime.now(),
              ),
            ));
      }),

      //
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .doc(widget.courseID)
            .collection('assignments')
            .where('moduleNo', isEqualTo: widget.classData.get('moduleNo'))
            .orderBy('classNo', descending: false)
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

          return Scrollbar(
            child: ListView.separated(
              // physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: data.length,
              itemBuilder: (context, index) {
                // class date
                DateTime now = DateTime.now();
                DateTime classTime = data[index].get('assignmentDate').toDate();
                // count down
                int endDate = classTime.millisecondsSinceEpoch + 1000 * 30;
                //
                // String status = '';
                // Color statusColor = Colors.grey;
                //
                // // up
                // if (widget.moduleStatus == StatusEnum.upcoming.name) {
                //   status = StatusEnum.upcoming.name;
                //   statusColor = Colors.red;
                // } else {
                //   // Define the start and end times of the class
                //   DateTime startTime =
                //       classTime.subtract(const Duration(minutes: 10));
                //   DateTime endTime =
                //       classTime.add(const Duration(minutes: 180));
                //
                //   //
                //   if (now.isAfter(startTime) && now.isBefore(endTime)) {
                //     status = StatusEnum.running.name;
                //     statusColor = Colors.red;
                //   } else if (now.isAfter(endTime)) {
                //     status = StatusEnum.completed.name;
                //     statusColor = Colors.green;
                //   } else {
                //     // If the current time is before the class time, the class is upcoming
                //     status = StatusEnum.ongoing.name;
                //     statusColor = Colors.orange;
                //   }
                // }

                //
                List submitterList = [];
                String submitterID = '';
                int obtainMark = 0;
                String assignmentStatus = AssignmentStatus.pending.name;

                String currentUserID = FirebaseAuth.instance.currentUser!.uid;
                submitterList = data[index].get('submitterList');

                //
                for (var submitter in submitterList) {
                  submitterID = submitter['submitterID'];
                  if (submitterID == currentUserID) {
                    obtainMark = submitter['obtainMark'];
                    if (obtainMark == 0) {
                      assignmentStatus = AssignmentStatus.submitted.name;
                    } else {
                      assignmentStatus = AssignmentStatus.approved.name;
                    }
                  }
                }

                // card
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //todo: assignment status
                              // Container(
                              //   decoration: BoxDecoration(
                              //     color: statusColor,
                              //     borderRadius: BorderRadius.circular(4),
                              //   ),
                              //   padding: const EdgeInsets.symmetric(
                              //       vertical: 2.5, horizontal: 12),
                              //   child: Text(
                              //     status.toUpperCase(),
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .bodySmall!
                              //         .copyWith(
                              //           color: Colors.white,
                              //         ),
                              //   ),
                              // ),

                              // const SizedBox(width: 12),

                              // date
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 1,
                                  horizontal: 10,
                                ),
                                child: Text(
                                  DTFormatter.dateWithTime(data[index]
                                      .get('assignmentDate')
                                      .toDate()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                ),
                              ),
                            ],
                          ),

                          // marks
                          if (assignmentStatus ==
                              AssignmentStatus.approved.name)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.green,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 4,
                              ),
                              child: Text(
                                "Marks: $obtainMark/${data[index].get('assignmentMarks')}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                              ),
                            ),

                          // todo: assignment admin
                          // if (now.isAfter(classTime))
                          //   AdminButton(
                          //     onPressed: () {},
                          //     child: GestureDetector(
                          //       onTap: () {
                          //         // Navigator.push(
                          //         //     context,
                          //         //     MaterialPageRoute(
                          //         //         builder: (context) =>
                          //         //             AddClassMaterials(
                          //         //               courseID: widget.courseID,
                          //         //               moduleNo: widget.classData
                          //         //                   .get('moduleNo'),
                          //         //               classData: data[index],
                          //         //             )));
                          //       },
                          //       child: const Icon(
                          //         Icons.add_box_outlined,
                          //         size: 32,
                          //         color: Colors.blueGrey,
                          //       ),
                          //     ),
                          //   )
                        ],
                      ),

                      const SizedBox(height: 4),

                      const Divider(),

                      //2
                      Text(
                        data[index].get('assignmentTitle'),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              // color: Colors.white,
                            ),
                      ),

                      const SizedBox(height: 10),

                      // check btn
                      if (assignmentStatus == AssignmentStatus.approved.name)
                        MaterialButton(
                          onPressed: () {
                            //
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SubmitAssignment(
                                        courseID: widget.courseID,
                                        assignmentData: data[index],
                                      )),
                            );
                          },
                          color: Colors.grey.shade200,
                          elevation: 0,
                          padding: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //icon
                              const Icon(
                                Icons.remove_red_eye_outlined,
                                size: 20,
                              ),

                              const SizedBox(width: 8),

                              // label
                              Text(
                                'Check Feedback',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        // fontWeight: FontWeight.bold,
                                        // color: Colors.white,
                                        ),
                              ),
                            ],
                          ),
                        ),

                      //
                      if (widget.moduleStatus != StatusEnum.upcoming.name)
                        CountdownTimer(
                            endTime: endDate,
                            widgetBuilder: (context, time) {
                              return Column(
                                children: [
                                  if (time != null)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        //
                                        if (assignmentStatus !=
                                            AssignmentStatus.approved.name)
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.watch_later_outlined,
                                                size: 18,
                                                color: Colors.deepOrange,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${time.days != null ? '${time.days} day ' : ''}'
                                                '${time.hours != null ? '${time.hours} hour ' : ''}'
                                                '${time.min != null ? '${time.min} min ' : ''}'
                                                '${time.sec != null ? '${time.sec} sec ' : ''}left',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      color: Colors.deepOrange,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        const SizedBox(height: 8),

                                        // submit btn
                                        if (assignmentStatus !=
                                            AssignmentStatus.approved.name) ...[
                                          MaterialButton(
                                            onPressed: () async {
                                              //
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SubmitAssignment(
                                                    courseID: widget.courseID,
                                                    assignmentData: data[index],
                                                  ),
                                                ),
                                              );
                                            },
                                            color: assignmentStatus ==
                                                    AssignmentStatus
                                                        .submitted.name
                                                ? Colors.green
                                                    .shade300 // Change color if assignment is already submitted
                                                : Colors.amber.shade200,
                                            // Default color
                                            elevation: 0,
                                            padding: const EdgeInsets.all(8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                //icon
                                                Icon(
                                                  assignmentStatus ==
                                                          AssignmentStatus
                                                              .submitted.name
                                                      ? Icons
                                                          .fact_check_outlined
                                                      : Icons.add_card_sharp,
                                                  size: 18,
                                                  color: assignmentStatus ==
                                                          AssignmentStatus
                                                              .submitted.name
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),

                                                const SizedBox(width: 8),

                                                // label
                                                Text(
                                                  assignmentStatus ==
                                                          AssignmentStatus
                                                              .submitted.name
                                                      ? 'Assignment Submitted' // Change text if assignment is already submitted
                                                      : 'Submit Assignment',
                                                  // Default text
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: assignmentStatus ==
                                                                AssignmentStatus
                                                                    .submitted
                                                                    .name
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          const SizedBox(height: 0),

                                          // warning
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.warning_amber_rounded,
                                                size: 16,
                                                color: Colors.blueGrey,
                                              ),

                                              const SizedBox(width: 5),

                                              //
                                              Text(
                                                assignmentStatus ==
                                                        AssignmentStatus
                                                            .submitted.name
                                                    ? "Resubmit until deadline!"
                                                    : "Submit before the deadline!",
                                                style: const TextStyle(
                                                    height: 2.1),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  if (assignmentStatus ==
                                          AssignmentStatus.pending.name &&
                                      time == null)

                                    //
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          size: 16,
                                          color: Colors.red,
                                        ),

                                        SizedBox(width: 8),

                                        //
                                        Text(
                                          "Time's up! You missed the deadline...",
                                          style: TextStyle(
                                            height: 2,
                                            fontSize: 15,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (assignmentStatus ==
                                          AssignmentStatus.submitted.name &&
                                      time == null)
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.data_usage_outlined,
                                          size: 16,
                                          color: Colors.teal,
                                        ),

                                        SizedBox(width: 8),

                                        //
                                        Text(
                                          "Review in progress! Be patient...",
                                          style: TextStyle(
                                            height: 1.8,
                                            fontSize: 15,
                                            color: Colors.teal,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              );
                            })
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
