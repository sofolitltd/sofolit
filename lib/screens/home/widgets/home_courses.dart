import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sofolit/screens/home/home_details.dart';
import 'package:sofolit/utils/date_time_formatter.dart';

class HomeCourses extends StatelessWidget {
  const HomeCourses({Key? key}) : super(key: key);

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
              height: 400,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return Container(
              height: 400,
              alignment: Alignment.center,
              child: const Text('Something went wrong'),
            );
          }
          var data = snapshot.data!.docs;
          List subscribers = [];
          for (var element in data) {
            subscribers = element.get('subscribers');
          }
          if (subscribers.contains(FirebaseAuth.instance.currentUser!.uid)) {
            return const Text('');
          }

          if (data.isEmpty) {
            return Container(
              height: 400,
              alignment: Alignment.center,
              child: const Text('No course found'),
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

                    //
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: TextButton(
                          onPressed: () {}, child: const Text('See more')),
                    ),
                  ],
                ),

                //
                SizedBox(
                  height: 350,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.grey,
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      List subscribers = data[index].get('subscribers');

                      if (subscribers
                          .contains(FirebaseAuth.instance.currentUser!.uid)) {
                        return const Text('');
                      }
                      return const SizedBox(width: 16);
                    },
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      //
                      List subscribers = data[index].get('subscribers');
                      if (subscribers
                          .contains(FirebaseAuth.instance.currentUser!.uid)) {
                        return const Text('');
                      }
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
            builder: (context) => HomeDetails(data: data),
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
          width: 300,
          child: Column(
            children: [
              //
              Stack(
                alignment: Alignment.topRight,
                children: [
                  //image
                  Container(
                    height: 160,
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

                  //
                  Container(
                    margin: const EdgeInsets.all(4),
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
                          '${data.get('discount')}% ',
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
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
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
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  data.get('batch'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),

                              const SizedBox(width: 4),

                              //time
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.watch_later_outlined,
                                    size: 20,
                                  ),

                                  const SizedBox(width: 4),

                                  //todo:
                                  FittedBox(
                                    child: Text(
                                      '${DTFormatter.dayFormat(data.get('lastDate'))} days remaining',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          //title
                          Text(
                            data.get('title'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
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
                                '৳ ${data.get('price')}',
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
                                '৳ ${data.get('price') - (data.get('price') * (data.get('discount') / 100)).round()}',
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

                              const SizedBox(width: 4),
                              //
                              Text(
                                '${data.get('seat')} seats left',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(),
                              ),
                            ],
                          ),
                        ],
                      ),

                      //btn
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeDetails(data: data),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Details'.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_right_alt_outlined),
                          ],
                        ),
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
