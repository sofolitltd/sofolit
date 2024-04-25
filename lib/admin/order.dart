import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum Status { pending, complete, cancel }

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return DefaultTabController(
      length: Status.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
          bottom: TabBar(
            padding: EdgeInsets.symmetric(
                horizontal: !isSmallScreen ? size.width * .2 : 0),
            labelColor: Colors.black,
            tabs: Status.values
                .map((e) => Tab(text: StringUtils.capitalize(e.name)))
                .toList(),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: !isSmallScreen ? size.width * .2 : 0),
          child: TabBarView(
            children:
                Status.values.map((e) => StatusTabs(title: e.name)).toList(),
          ),
        ),
      ),
    );
  }
}

//
class StatusTabs extends StatelessWidget {
  const StatusTabs({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('payments')
            .where('status', isEqualTo: title)
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
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              return OrderCard(data: data[index], title: title);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemCount: data.length,
          );
        });
  }
}

//
class OrderCard extends StatefulWidget {
  const OrderCard({super.key, required this.data, required this.title});

  final QueryDocumentSnapshot data;
  final String title;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderCardDetails(
                      data: widget.data,
                      title: widget.title,
                    )));
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${widget.data.get('courseBatch')} - ${widget.data.get('courseTitle')}'),
              Text('User: ${widget.data.get('userEmail')}'),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  color: widget.data.get('status') == Status.pending.name
                      ? Colors.orange.shade400
                      : widget.data.get('status') == Status.complete.name
                          ? Colors.green.shade400
                          : Colors.red.shade400,
                ),
                child: Text(
                  StringUtils.capitalize(widget.data.get('status')),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderCardDetails extends StatefulWidget {
  const OrderCardDetails({super.key, required this.data, required this.title});

  final QueryDocumentSnapshot data;
  final String title;

  @override
  State<OrderCardDetails> createState() => _OrderCardDetailsState();
}

class _OrderCardDetailsState extends State<OrderCardDetails> {
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.data.get('status');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: !isSmallScreen ? size.width * .2 : 0),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).cardColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Batch: ' + widget.data.get('courseBatch')),
              Text("Title" + widget.data.get('courseTitle')),
              Text('User: ${widget.data.get('userEmail')}'),
              Text('Mobile: ${widget.data.get('mobile')}'),
              Text('Trans ID: ${widget.data.get('transaction')}'),
              Text('Amount: ৳${widget.data.get('coursePrice')}'),

              const SizedBox(height: 8),
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //
                  DropdownButtonHideUnderline(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(2)),
                        border:
                            Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: DropdownButton(
                          value: _selectedStatus,
                          items: Status.values
                              .map((e) => DropdownMenuItem<String>(
                                    value: e.name,
                                    child: Text(StringUtils.capitalize(e.name)),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            _selectedStatus = val;
                            setState(() {});
                          }),
                    ),
                  ),

                  const SizedBox(width: 16),
                  //
                  _selectedStatus == widget.title
                      ? Container()
                      : ElevatedButton(
                          onPressed: () async {
                            // change status
                            await FirebaseFirestore.instance
                                .collection('payments')
                                .doc(widget.data.id)
                                .update({
                              'status': _selectedStatus.toString(),
                            }).then((value) {
                              // _selectedStatus = null;
                            });

                            // add courses to user
                            var ref = FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.data.get('userID'));
                            if (_selectedStatus == 'complete') {
                              ref.update({
                                'courses': FieldValue.arrayUnion(
                                    [widget.data.get('courseBatch')])
                              });
                            } else {
                              ref.update({
                                'courses': FieldValue.arrayRemove(
                                    [widget.data.get('courseBatch')])
                              });
                            }

                            // add subscribers to course
                            var ref1 = FirebaseFirestore.instance
                                .collection('courses')
                                .where('courseBatch',
                                    isEqualTo: widget.data.get('courseBatch'));

                            ref1.get().then((querySnapshot) {
                              for (var doc in querySnapshot.docs) {
                                if (_selectedStatus == 'complete') {
                                  doc.reference.update({
                                    'enrolledStudents': FieldValue.arrayUnion(
                                        [widget.data.get('userID')])
                                  });
                                } else {
                                  doc.reference.update({
                                    'enrolledStudents': FieldValue.arrayRemove(
                                        [widget.data.get('userID')])
                                  });
                                }
                              }
                            }).catchError((error) {
                              print("Error getting documents: $error");
                            });

                            //
                            if (!mounted) return;
                            Navigator.pop(context);
                          },
                          child: const Text('Confirm'),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
