import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

import '/utils/date_time_formatter.dart';
import '/utils/open_app.dart';

class RecentSection1 extends StatelessWidget {
  const RecentSection1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .where('subscribers', arrayContainsAny: [
          FirebaseAuth.instance.currentUser!.uid
        ]).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 250,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }
          var data = snapshot.data!.docs;
          if (data.isEmpty) {
            return Center(
              child: Container(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          return const Text('okk');
          // return Container(
          //   height: 250,
          //   color: Theme.of(context).cardColor,
          //   margin: const EdgeInsets.only(top: 10),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.stretch,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       //head
          //       Padding(
          //         padding: const EdgeInsets.symmetric(
          //           horizontal: 16,
          //           vertical: 10,
          //         ),
          //         child: Text(
          //           'Recent',
          //           style: Theme.of(context).textTheme.titleMedium!.copyWith(
          //                 fontWeight: FontWeight.bold,
          //               ),
          //         ),
          //       ),
          //
          //       //
          //       SizedBox(
          //         height: 200,
          //         child: ListView.separated(
          //             separatorBuilder: (context, index) =>
          //                 const SizedBox(width: 10),
          //             padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          //             scrollDirection: Axis.horizontal,
          //             shrinkWrap: true,
          //             itemCount: data.length,
          //             itemBuilder: (context, index) {
          //               Timestamp ts = data[index].get('time') as Timestamp;
          //               DateTime dateTime = ts.toDate();
          //
          //               return Container(
          //                 height: 150,
          //                 width: 300,
          //                 padding: const EdgeInsets.symmetric(
          //                   vertical: 8,
          //                   horizontal: 12,
          //                 ),
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(8),
          //                   color: Colors.black87,
          //                 ),
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     //div1
          //                     Row(
          //                       children: [
          //                         //
          //                         Text(
          //                           'Upcoming',
          //                           style: Theme.of(context)
          //                               .textTheme
          //                               .titleMedium!
          //                               .copyWith(
          //                                 fontWeight: FontWeight.bold,
          //                                 color: Colors.white,
          //                               ),
          //                         ),
          //
          //                         const SizedBox(width: 8),
          //
          //                         //class
          //                         Stack(
          //                           alignment: Alignment.centerLeft,
          //                           children: [
          //                             //
          //                             Container(
          //                               decoration: BoxDecoration(
          //                                 borderRadius:
          //                                     BorderRadius.circular(50),
          //                                 color: Colors.red,
          //                               ),
          //                               margin: const EdgeInsets.only(left: 4),
          //                               padding: const EdgeInsets.fromLTRB(
          //                                   30, 2, 12, 2),
          //                               child: Text(
          //                                 'Live'.toUpperCase(),
          //                                 style: Theme.of(context)
          //                                     .textTheme
          //                                     .bodySmall!
          //                                     .copyWith(
          //                                       fontWeight: FontWeight.bold,
          //                                       color: Colors.white,
          //                                     ),
          //                               ),
          //                             ),
          //
          //                             //
          //                             const Icon(
          //                               Icons.play_circle,
          //                               color: Colors.white70,
          //                               size: 30,
          //                             ),
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //
          //                     const SizedBox(height: 6),
          //
          //                     //
          //                     Text(
          //                       data[index].get('courses'),
          //                       maxLines: 1,
          //                       overflow: TextOverflow.ellipsis,
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .labelMedium!
          //                           .copyWith(
          //                             color: Colors.white54,
          //                             // height: 1,
          //                           ),
          //                     ),
          //
          //                     Text(
          //                       data[index].get('title'),
          //                       maxLines: 1,
          //                       overflow: TextOverflow.ellipsis,
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .titleSmall!
          //                           .copyWith(
          //                             fontWeight: FontWeight.bold,
          //                             color: Colors.white70,
          //                             height: 1.3,
          //                           ),
          //                     ),
          //
          //                     const SizedBox(height: 12),
          //
          //                     //date
          //                     Row(
          //                       crossAxisAlignment: CrossAxisAlignment.center,
          //                       children: [
          //                         const Icon(
          //                           Icons.calendar_month_outlined,
          //                           color: Colors.white70,
          //                           size: 14,
          //                         ),
          //
          //                         const SizedBox(width: 4),
          //
          //                         //
          //                         Text(
          //                           DTFormatter.dateTimeFormat(
          //                               data[index].get('time')),
          //                           style: Theme.of(context)
          //                               .textTheme
          //                               .labelLarge!
          //                               .copyWith(
          //                                 color: Colors.white54,
          //                                 // height: 1,
          //                               ),
          //                         ),
          //                       ],
          //                     ),
          //
          //                     // const SizedBox(height: 8),
          //
          //                     //div 3
          //                     CountdownTimer(
          //                       endTime: DateTime(
          //                         dateTime.year,
          //                         dateTime.month,
          //                         dateTime.day,
          //                         dateTime.hour,
          //                         dateTime.minute,
          //                       ).millisecondsSinceEpoch,
          //                       widgetBuilder: (context, time) {
          //                         if (time == null) {
          //                           return GestureDetector(
          //                             onTap: () {
          //                               //
          //                             },
          //                             child: GestureDetector(
          //                               onTap: () {
          //                                 OpenApp.withUrl(
          //                                     data[index].get('meeting'));
          //                               },
          //                               child: Container(
          //                                 decoration: BoxDecoration(
          //                                   color: Colors.yellow,
          //                                   borderRadius:
          //                                       BorderRadius.circular(4),
          //                                 ),
          //                                 margin: const EdgeInsets.only(
          //                                   top: 4,
          //                                   bottom: 2,
          //                                 ),
          //                                 padding: const EdgeInsets.fromLTRB(
          //                                     20, 5, 25, 5),
          //                                 child: Row(
          //                                   mainAxisSize: MainAxisSize.min,
          //                                   children: const [
          //                                     Icon(Icons.video_call_outlined),
          //
          //                                     SizedBox(width: 4),
          //                                     //
          //                                     Text('Join now'),
          //                                   ],
          //                                 ),
          //                               ),
          //                             ),
          //                           );
          //                         }
          //
          //                         return Row(
          //                           children: [
          //                             const Icon(
          //                               Icons.timer_outlined,
          //                               color: Colors.deepOrangeAccent,
          //                               size: 20,
          //                             ),
          //                             const SizedBox(width: 4),
          //
          //                             //
          //                             Text(
          //                               '${time.days ?? 0}d : ${time.hours ?? 0}h ${time.min ?? 0}m ${time.sec ?? 0}s',
          //                               style: Theme.of(context)
          //                                   .textTheme
          //                                   .titleMedium!
          //                                   .copyWith(
          //                                     fontWeight: FontWeight.bold,
          //                                     color: Colors.deepOrangeAccent,
          //                                   ),
          //                             ),
          //                           ],
          //                         );
          //                       },
          //                     ),
          //                   ],
          //                 ),
          //               );
          //             }),
          //       ),
          //     ],
          //   ),
          // );
        });
  }
}

//todo: copy
class RecentSection extends StatelessWidget {
  const RecentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('recent')
            .orderBy('time', descending: false)
            .where('subscribers', arrayContainsAny: [
          FirebaseAuth.instance.currentUser!.uid
        ]).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 250,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }
          var data = snapshot.data!.docs;
          if (data.isEmpty) {
            return Center(
              child: Container(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          return Container(
            height: 250,
            color: Theme.of(context).cardColor,
            margin: const EdgeInsets.only(top: 10),
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
                    'Recent',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),

                //
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        Timestamp ts = data[index].get('time') as Timestamp;
                        DateTime dateTime = ts.toDate();

                        return Container(
                          height: 150,
                          width: 300,
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black87,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //div1
                              Row(
                                children: [
                                  //
                                  Text(
                                    'Upcoming',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                  ),

                                  const SizedBox(width: 8),

                                  //live
                                  Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      //
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.red,
                                        ),
                                        margin: const EdgeInsets.only(left: 4),
                                        padding: const EdgeInsets.fromLTRB(
                                            30, 2, 12, 2),
                                        child: Text(
                                          'Live'.toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),

                                      //
                                      const Icon(
                                        Icons.play_circle,
                                        color: Colors.white70,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              //
                              Text(
                                data[index].get('courses'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                      color: Colors.white54,
                                      // height: 1,
                                    ),
                              ),

                              Text(
                                data[index].get('title'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70,
                                      height: 1.3,
                                    ),
                              ),

                              const SizedBox(height: 12),

                              //date
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.white70,
                                    size: 14,
                                  ),

                                  const SizedBox(width: 4),

                                  //
                                  Text(
                                    DTFormatter.dateWithTime(
                                        data[index].get('time')),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                          color: Colors.white54,
                                          // height: 1,
                                        ),
                                  ),
                                ],
                              ),

                              // const SizedBox(height: 8),

                              //div 3
                              CountdownTimer(
                                endTime: DateTime(
                                  dateTime.year,
                                  dateTime.month,
                                  dateTime.day,
                                  dateTime.hour,
                                  dateTime.minute,
                                ).millisecondsSinceEpoch,
                                widgetBuilder: (context, time) {
                                  if (time == null) {
                                    return GestureDetector(
                                      onTap: () {
                                        //
                                      },
                                      child: GestureDetector(
                                        onTap: () {
                                          OpenApp.withUrl(
                                              data[index].get('meeting'));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.yellow,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          margin: const EdgeInsets.only(
                                            top: 4,
                                            bottom: 2,
                                          ),
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 5, 25, 5),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.video_call_outlined),

                                              SizedBox(width: 4),
                                              //
                                              Text('Join now'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  return Row(
                                    children: [
                                      const Icon(
                                        Icons.timer_outlined,
                                        color: Colors.deepOrangeAccent,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 4),

                                      //
                                      Text(
                                        '${time.days ?? 0}d : ${time.hours ?? 0}h ${time.min ?? 0}m ${time.sec ?? 0}s',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepOrangeAccent,
                                            ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }
}
