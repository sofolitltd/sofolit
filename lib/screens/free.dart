import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sofolit/utils/open_app.dart';

class Free extends StatelessWidget {
  const Free({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Free'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: !isSmallScreen ? size.width * .1 : 0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('free').snapshots(),
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
              itemCount: data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FreeDetails(
                            data: data[index],
                          ),
                        ),
                      );
                    },
                    title: Text('${data[index].get('title')}'),
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 40,
                      height: 40,
                      color: Colors.grey.shade100,
                      child: const Text(''),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class FreeDetails extends StatelessWidget {
  const FreeDetails({super.key, required this.data});

  final QueryDocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        centerTitle: isSmallScreen ? false : true,
        title: Text(data.get('title')),
      ),

      //
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: !isSmallScreen ? size.width * .2 : 0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('free')
              .doc(data.id)
              .collection('items')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var data1 = snapshot.data!.docs;
            if (data1.isEmpty) {
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
              itemCount: data1.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: () {
                      //
                      OpenApp.withUrl(data1[index].get('url'));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        Expanded(
                          flex: isSmallScreen ? 3 : 3,
                          child: Container(
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(''),
                          ),
                        ),

                        const SizedBox(width: 16),

                        //
                        Expanded(
                          flex: isSmallScreen ? 10 : 9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data1[index].get('title')}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '${data1[index].get('description')}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.black54,
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
            );
          },
        ),
      ),
    );
  }
}
