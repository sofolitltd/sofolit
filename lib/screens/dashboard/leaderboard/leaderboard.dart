import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  void initState() {
    super.initState();
    var ref = FirebaseFirestore.instance.collection('courses').doc(widget.uid);

    Set subscribers = {};
    int sum = 0;
    List<int> marks = [];
    //
    ref.collection('assignment').get().then((ass) {
      ass.docs.forEach((assDoc) {
        assDoc.reference.collection('subscribers').get().then((subs) {
          subs.docs.forEach((sub) {
            subscribers.add(sub.id);
            print(subscribers);

            //add sub
            marks.add(sub.get('marks'));

            //
            for (var subscriber in subscribers) {
              //
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(subscriber)
                  .get()
                  .then((doc) {
                var name = doc.get('name');

                //
                ref.collection('leaderboard').doc(doc.id).set({
                  'name': name,
                  'point': 0,
                  'uid': doc.id,
                });
              });
            }
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: kIsWeb
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                var ref = FirebaseFirestore.instance
                    .collection('courses')
                    .doc(widget.uid);

                Set subscribers = {};
                int sum = 0;
                List<int> marks = [];
                //
                ref.collection('assignment').get().then((ass) {
                  ass.docs.forEach((assDoc) {
                    assDoc.reference
                        .collection('subscribers')
                        .get()
                        .then((subs) {
                      subs.docs.forEach((sub) {
                        subscribers.add(sub.id);
                        print(subscribers);

                        //add sub
                        marks.add(sub.get('marks'));

                        //count total
                        for (var i in marks) {
                          sum += i;
                        }
                        print(marks);
                        print(sum);

                        //
                        for (var subscriber in subscribers) {
                          //
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(subscriber)
                              .get()
                              .then((doc) {
                            var name = doc.get('name');

                            //
                            ref.collection('leaderboard').doc(doc.id).set({
                              'name': name,
                              'point': 0,
                              'uid': doc.id,
                            });
                          });
                        }
                      });
                    });
                  });
                });

                //
              },
            ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('courses')
              .doc(widget.uid)
              .collection('leaderboard')
              .orderBy('point')
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
            return Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Leaderboard',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const Divider(height: 2),

                  //
                  ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 4),
                    shrinkWrap: true,
                    itemCount: data.length,
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                    itemBuilder: (context, index) {
                      var uid = FirebaseAuth.instance.currentUser!.uid;

                      return Container(
                        color: data[index].get('uid') == uid
                            ? Colors.yellow.shade200
                            : Theme.of(context).cardColor,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          minLeadingWidth: 0,
                          leading: Text(
                            '${index + 1}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          title: Text(StringUtils.capitalize(
                              '${data[index].get('name')}',
                              allWords: true)),
                          trailing: FittedBox(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    '${data[index].get('point')}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Text(
                                  'points',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.w100,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }
}
