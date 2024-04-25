import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sofolit/screens/courses/modules/assignment/assignment_add.dart';

import '../modules.dart';
import '../video_player_web.dart';
import '/admin/admin_button.dart';
import '/screens/courses/modules/Class/class_add.dart';
import '/screens/courses/modules/Class/class_add_materials.dart';
import '/utils/date_time_formatter.dart';
import '/utils/open_app.dart';

class Class extends StatefulWidget {
  const Class({
    super.key,
    required this.courseID,
    required this.classData,
    required this.moduleStatus,
  });

  final String courseID;
  final QueryDocumentSnapshot classData;
  final String moduleStatus;

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      floatingActionButton: AdminButton(onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddLive(
                courseID: widget.courseID,
                moduleNo: widget.classData.get('moduleNo'),
              ),
            ));
      }),

      //
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .doc(widget.courseID)
            .collection('classes')
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
                DateTime classTime = data[index].get('classDate').toDate();
                // count down
                int endDate = classTime.millisecondsSinceEpoch + 1000 * 30;

                String status = '';
                Color statusColor = Colors.grey;

                // up
                if (widget.moduleStatus == StatusEnum.upcoming.name) {
                  status = StatusEnum.upcoming.name;
                  statusColor = Colors.red;
                } else {
                  // Define the start and end times of the class
                  DateTime startTime =
                      classTime.subtract(const Duration(minutes: 10));
                  DateTime endTime =
                      classTime.add(const Duration(minutes: 180));

                  //
                  if (now.isAfter(startTime) && now.isBefore(endTime)) {
                    status = StatusEnum.running.name;
                    statusColor = Colors.red;
                  } else if (now.isAfter(endTime)) {
                    status = StatusEnum.completed.name;
                    statusColor = Colors.green;
                  } else {
                    // If the current time is before the class time, the class is upcoming
                    status = StatusEnum.ongoing.name;
                    statusColor = Colors.orange;
                  }
                }

                //
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
                              //status
                              Container(
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2.5, horizontal: 12),
                                child: Text(
                                  status.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),

                              const SizedBox(width: 12),

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
                                  DTFormatter.dateWithTime(
                                      data[index].get('classDate').toDate()),
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

                          // admin
                          if (now.isAfter(classTime))
                            AdminButton(
                              onPressed: () {},
                              child: Row(
                                children: [
                                  // video
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddClassMaterials(
                                                    courseID: widget.courseID,
                                                    moduleNo: widget.classData
                                                        .get('moduleNo'),
                                                    classData: data[index],
                                                  )));
                                    },
                                    child: const Icon(
                                      Icons.add_box_outlined,
                                      size: 24,
                                      color: Colors.blueGrey,
                                    ),
                                  ),

                                  const SizedBox(width: 4),
                                  // assignment
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddAssignment(
                                                    courseID: widget.courseID,
                                                    moduleNo: widget.classData
                                                        .get('moduleNo'),
                                                    classNo: data[index]
                                                        .get('classNo'),
                                                    classTitle: data[index]
                                                        .get('classTitle'),
                                                    classDate: data[index]
                                                        .get('classDate')
                                                        .toDate(),
                                                  )));
                                    },
                                    child: const Icon(
                                      Icons.add_card_outlined,
                                      size: 24,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),

                      const SizedBox(height: 4),

                      const Divider(),

                      //2
                      Text(
                        data[index].get('classTitle'),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              // color: Colors.white,
                            ),
                      ),

                      const SizedBox(height: 10),

                      //3
                      if (data[index].get('classVideo')[0] != '')
                        MaterialButton(
                          onPressed: () {
                            // play page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VideoPlayer(
                                        data: data[index],
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
                                Icons.play_circle_outlined,
                                // size: 14,
                              ),

                              const SizedBox(width: 8),

                              // label
                              Text(
                                'Class Recoding',
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
                            // remain
                            DateTime endTime =
                                classTime.add(const Duration(minutes: 180));

                            //
                            bool isClassStart = false;
                            bool isClassFinished = now.isBefore(endTime);

                            if (time != null) {
                              if (time.days == null || time.hours == null) {
                                if ((time.min != null &&
                                        (time.min! < 4 || time.min == 4)) ||
                                    (time.min == null && time.sec != null)) {
                                  isClassStart = true;
                                }
                              } else {
                                isClassStart = false;
                              }
                            } else {
                              // All properties of time are null
                              isClassStart = true;
                            }

                            //
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (time != null)
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
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),

                                const SizedBox(height: 8),

                                // join btn, msg
                                if (isClassStart) ...[
                                  //join
                                  if (isClassFinished &&
                                      data[index].get("classVideo")[0] == '')

                                    //join btn
                                    MaterialButton(
                                      onPressed: () async {
                                        String classLink =
                                            data[index].get('classLink');
                                        if (classLink.isNotEmpty) {
                                          await OpenApp.withUrl(classLink);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'No link found!');
                                        }
                                      },
                                      color: Colors.orange.shade200,
                                      elevation: 0,
                                      padding: const EdgeInsets.all(8),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          //icon
                                          const Icon(
                                            Icons.ads_click,
                                            size: 18,
                                          ),

                                          const SizedBox(width: 8),

                                          // label
                                          Text(
                                            'Join Live Class',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  // color: Colors.black54,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  //
                                  if (!isClassFinished &&
                                      data[index].get("classVideo")[0] == '')
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.watch_later_outlined,
                                          size: 32,
                                          color: Colors.blueGrey,
                                        ),
                                        SizedBox(width: 16),

                                        //
                                        Expanded(
                                          child: Text(
                                            "Please wait! We will upload the class materials soon...",
                                            style: TextStyle(height: 1.2),
                                          ),
                                        ),
                                      ],
                                    ),

                                  //
                                ],
                              ],
                            );
                          },
                        ),
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
