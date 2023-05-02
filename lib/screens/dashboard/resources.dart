import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sofolit/screens/admin/admin_button.dart';
import 'package:sofolit/utils/open_app.dart';

import '../../utils/date_time_formatter.dart';

class Resources extends StatelessWidget {
  const Resources({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AdminButton(
        onPressed: () {
          //   var ref = FirebaseFirestore.instance
          //       .collection('courses')
          //       .doc(uid)
          //       .collection('resource');
          //   ref.doc().set({
          //     'title': 'Figma ',
          //     'description': 'Learn about figma',
          //     'url': '',
          //     'time': DateTime.now(),
          //   });
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('courses')
              .doc(uid)
              .collection('resource')
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
            return ListView.separated(
              shrinkWrap: true,
              itemCount: data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  child: ListTile(
                    onTap: () {
                      OpenApp.withUrl(data[index].get('url'));
                    },
                    title: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data[index].get('title'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            data[index].get('description'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(height: 1, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    subtitle: // date
                        Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 8,
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_month_outlined,
                                size: 16,
                              ),

                              const SizedBox(width: 4),

                              //
                              Text(DTFormatter.dateTimeFormat(
                                  data[index].get('time'))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
