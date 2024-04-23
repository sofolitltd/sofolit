import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sofolit/utils/open_app.dart';

import '/utils/date_time_formatter.dart';

class Joining extends StatelessWidget {
  const Joining({
    super.key,
    required this.courseID,
  });

  final String courseID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Live Class Joining'),
        ),
        //
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('courses')
              .doc(courseID)
              .collection('lives')
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
            DateTime now = DateTime.now();

            var todayClasses = data.where((doc) {
              DateTime classDate = doc.get('classDate').toDate();
              return classDate.year == now.year &&
                  classDate.month == now.month &&
                  classDate.day == now.day;
            }).toList();

            if (todayClasses.isEmpty) {
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
                        'No scheduled classes for today!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Use this time for personal study or skill development',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey[400], height: 1.2),
                      ),
                    ),
                  ],
                ),
              );
            }

            //
            return ListView.separated(
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemCount: todayClasses.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                return JoiningCard(data: todayClasses[index]);
              },
            );
          },
        ));
  }
}

//
class JoiningCard extends StatefulWidget {
  const JoiningCard({super.key, required this.data});
  final QueryDocumentSnapshot data;

  @override
  State<JoiningCard> createState() => _JoiningCardState();
}

class _JoiningCardState extends State<JoiningCard> {
  @override
  Widget build(BuildContext context) {
    DateTime classDate = widget.data.get('classDate').toDate();
    int endDate = classDate.millisecondsSinceEpoch + 1000 * 30;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //module
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 1, horizontal: 12),
                child: Text(
                  'Live',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ),

              const SizedBox(width: 12),

              // date
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 1,
                  horizontal: 10,
                ),
                child: Text(
                  DTFormatter.dateWithTime(
                      widget.data.get('classDate').toDate()),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          const Divider(),

          //2
          Text(
            widget.data.get('title'),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  // color: Colors.white,
                ),
          ),

          const SizedBox(height: 10),

          //
          Row(
            children: [
              //
              Container(
                width: 94,
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 3),
                child: Text(
                  'Module  ${widget.data.get('moduleNo')}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                ),
              ),
              const SizedBox(width: 12),

              //
              Container(
                width: 74,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.fromLTRB(8, 8, 10, 3),
                child: Text(
                  'Class  ${widget.data.get('classNo')}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                ),
              ),

              const Spacer(),
              //
              const Icon(
                Icons.keyboard_arrow_right_outlined,
                color: Colors.black54,
                size: 24,
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Divider(height: 24),

          //
          CountdownTimer(
            endTime: endDate,
            widgetBuilder: (context, CurrentRemainingTime? time) {
              // remain
              DateTime startTime =
                  classDate.subtract(const Duration(minutes: 10));
              DateTime endTime = classDate.add(const Duration(minutes: 180));

              //
              bool isClassStart = false;
              bool isClassFinished = DateTime.now().isBefore(endTime);

              if (time != null) {
                if (time.days == null || time.hours == null) {
                  if ((time.min != null && (time.min! < 4 || time.min == 4)) ||
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
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  // Only show the buttons if there's no remaining time or less than 10 minutes remaining
                  if (isClassStart) ...[
                    //join
                    if (isClassFinished)

                      //join btn
                      MaterialButton(
                        onPressed: () async {
                          String classLink = widget.data.get('classLink');
                          if (classLink.isNotEmpty) {
                            await OpenApp.withUrl(classLink);
                          } else {
                            Fluttertoast.showToast(msg: 'No link found!');
                          }
                        },
                        color: Colors.orange.shade200,
                        elevation: 0,
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                    if (!isClassFinished)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.nearby_error,
                            size: 40,
                            color: Colors.deepOrange.shade300,
                          ),

                          const SizedBox(width: 10),

                          //
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //
                                Text(
                                  "This class already finished!".toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),

                                const SizedBox(height: 4),

                                //
                                Text(
                                  'Check "MODULES" or "RECORDING" section for video, material and more...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        // color: Colors.deepOrange,
                                        height: 1.4,
                                      ),
                                ),
                              ],
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
  }
}
