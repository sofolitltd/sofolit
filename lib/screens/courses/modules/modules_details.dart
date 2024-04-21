import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../utils/date_time_formatter.dart';
import '/screens/courses/modules/video_player.dart';

class ModulesDetails extends StatelessWidget {
  const ModulesDetails({
    super.key,
    required this.data,
  });

  final QueryDocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    DateTime startTime = data.get('startTime').toDate();
    DateTime finishTime = data.get('finishTime').toDate();

    return Scaffold(
      appBar: AppBar(
        title: Text('Module - ${data.get('moduleNo')}'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // 1
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //1
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 10,
                    ),
                    child: Text(
                      DTFormatter.date(startTime) +
                          " - " +
                          DTFormatter.date(finishTime),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  //2
                  Text(
                    data.get('moduleTitle'),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          // color: Colors.white,
                        ),
                  ),

                  const SizedBox(height: 10),

                  //3
                  Row(
                    children: [
                      // class
                      Row(
                        children: [
                          //icon
                          const Icon(
                            Icons.video_call_outlined,
                            size: 18,
                          ),

                          const SizedBox(width: 4),

                          // label
                          Text(
                            '2 Live Class',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    // fontWeight: FontWeight.bold,
                                    // color: Colors.white,
                                    ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 24),

                      // assignment
                      Row(
                        children: [
                          //icon
                          const Icon(
                            Icons.assignment,
                            size: 14,
                          ),

                          const SizedBox(width: 4),

                          // label
                          Text(
                            '2 Assignment',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    // fontWeight: FontWeight.bold,
                                    // color: Colors.white,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Divider(),
                ],
              ),
            ),

            // 2
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,

                  indicator: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  // isScrollable: true,
                  tabs: [
                    Tab(text: 'Live Class'),
                    Tab(text: 'Assignment'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            //3
            Expanded(
              child: TabBarView(
                children: [
                  // 1
                  ListView.separated(
                    // physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: 2,
                    itemBuilder: (context, index) {
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //module
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 1, horizontal: 12),
                                  child: Text(
                                    'Live',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                  ),
                                ),

                                const SizedBox(width: 16),

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
                                    '18 April - 24 April',
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

                            const Divider(),

                            //2
                            Text(
                              'The ultimate freelancing guide',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    // color: Colors.white,
                                  ),
                            ),

                            const SizedBox(height: 10),

                            //3
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const VideoPlayer()),
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
                          ],
                        ),
                      );
                    },
                  ),

                  // 2
                  ListView.separated(
                    // physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => DashboardDetails(
                          //             uid: 'uid', title: 'title')));
                        },
                        child: Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //module
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1, horizontal: 12),
                                    child: Text(
                                      'Live',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),

                                  // date
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.shade400,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 1,
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      '18 April - 24 April',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ],
                              ),

                              const Divider(),

                              //2
                              Text(
                                'The ultimate freelancing guide',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      // color: Colors.white,
                                    ),
                              ),

                              const SizedBox(height: 10),

                              //3
                              MaterialButton(
                                onPressed: () {},
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
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
