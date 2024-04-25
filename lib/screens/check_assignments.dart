import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sofolit/utils/open_app.dart';

enum Status { submitted, approved }

class CheckAssignment extends StatelessWidget {
  const CheckAssignment({
    super.key,
    required this.courseID,
  });

  final String courseID;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return DefaultTabController(
      length: Status.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Check Assignments'),
          bottom: TabBar(
            padding: EdgeInsets.symmetric(
                horizontal: !isSmallScreen ? size.width * .2 : 0),
            labelColor: Colors.black,
            tabs: Status.values
                .map((e) => Tab(text: StringUtils.capitalize(e.name)))
                .toList(),
          ),
        ),

        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('courses')
                .doc(courseID)
                .collection('assignments')
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

              //
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: data.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
                itemBuilder: (context, index) {
                  return CheckAssignmentsCard(
                    data: data[index],
                    title: 'Pending',
                  );
                },
              );
            }),
        // body: Padding(
        //   padding: EdgeInsets.symmetric(
        //       horizontal: !isSmallScreen ? size.width * .2 : 0),
        //   child: TabBarView(
        //     // children: Status.values
        //     //     .map((e) => StatusTabs(title: StringUtils.capitalize(e.name)))
        //     //     .toList(),
        //     children: [
        //       StatusTabs(title: 'Pending'),
        //       StatusTabs(title: 'Approved'),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}

//
class StatusTabs extends StatelessWidget {
  const StatusTabs({
    super.key,
    required this.title,
    required this.courseID,
    required this.assignmentID,
  });

  final String title;
  final String courseID;
  final String assignmentID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .doc(courseID)
            .collection('assignments')
            // .doc(assignmentID)
            // .orderBy('moduleNo', descending: true)
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

          //
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemBuilder: (context, index) {
              return CheckAssignmentsCard(data: data[index], title: title);
            },
          );
        });
  }
}

// card
class CheckAssignmentsCard extends StatelessWidget {
  const CheckAssignmentsCard(
      {super.key, required this.data, required this.title});

  final QueryDocumentSnapshot data;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdminAssignmentCardDetails(
                      data: data,
                      title: title,
                    )));
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email: {data.get('email')}"),
              const SizedBox(height: 8),

              //
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  // color: data.get('status') == 'Submitted'
                  //     ? Colors.blue.shade400
                  //     : Colors.green.shade400,
                ),
                child: Text(
                  "{data.get('status')}",
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

// details
class AdminAssignmentCardDetails extends StatefulWidget {
  const AdminAssignmentCardDetails(
      {super.key, required this.data, required this.title});

  final QueryDocumentSnapshot data;
  final String title;

  @override
  State<AdminAssignmentCardDetails> createState() =>
      _AdminAssignmentCardDetailsState();
}

class _AdminAssignmentCardDetailsState
    extends State<AdminAssignmentCardDetails> {
  String? _selectedStatus;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _obtainMarkController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    String status = StringUtils.capitalize(widget.data.get('status'));
    String obtainMark = widget.data.get('obtainMark').toString();
    String feedback = widget.data.get('feedback');
    _selectedStatus = status;
    if (status == 'Approved') {
      _obtainMarkController.text = obtainMark;
      _feedbackController.text = feedback;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment Details'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Padding(
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
                  Text(widget.data.get('assignmentId')),
                  Text('User: ${widget.data.get('email')}'),
                  GestureDetector(
                    onTap: () {
                      if (widget.data.get('url') == null) return;
                      OpenApp.withUrl(widget.data.get('url'));
                    },
                    child: Text(
                      'Url: ${widget.data.get('url')}',
                      style:
                          const TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                  Text('Feedback: ${widget.data.get('feedback')}'),
                  Text('Obtain: ${widget.data.get('obtainMark')}'),
                  Text('Total: ${widget.data.get('totalMark')}'),

                  const SizedBox(height: 16),

                  //
                  TextFormField(
                    controller: _obtainMarkController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(),
                      hintText: 'Marks',
                      label: Text('Marks'),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Enter mark' : null,
                  ),

                  const SizedBox(height: 16),

                  //
                  TextFormField(
                    controller: _feedbackController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(),
                      hintText: 'Feedback',
                      label: Text('Feedback'),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 4,
                    // validator: (value) =>
                    //     value!.isEmpty ? 'Enter feedback' : null,
                  ),

                  const SizedBox(height: 16),
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
                            border: Border.all(
                                color: Theme.of(context).dividerColor),
                          ),
                          child: DropdownButton(
                              value: _selectedStatus,
                              items: Status.values
                                  .map((e) => DropdownMenuItem<String>(
                                        value: StringUtils.capitalize(e.name),
                                        child: Text(
                                            StringUtils.capitalize(e.name)),
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
                      _selectedStatus == 'Submitted'
                          ? Container()
                          : ElevatedButton(
                              onPressed: () async {
                                if (_globalKey.currentState!.validate()) {
                                  //
                                  String name = '';
                                  var userRef = FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.data.get('uid'))
                                      .get()
                                      .then((value) {
                                    name = value.get('name');
                                  });

                                  //
                                  var ref = FirebaseFirestore.instance
                                      .collection('courses')
                                      .doc('courseID');

                                  //
                                  var newObtainMark = int.parse(
                                      _obtainMarkController.text.trim());

                                  var oldObtainMark =
                                      widget.data.get('obtainMark');
                                  var feedback =
                                      _feedbackController.text.trim().isEmpty
                                          ? ''
                                          : _feedbackController.text.trim();

                                  //
                                  ref
                                      .collection('assignments')
                                      .doc(widget.data.id)
                                      .update({
                                    'status': _selectedStatus,
                                    'feedback': feedback,
                                    'obtainMark': newObtainMark,
                                  }).then((value) {
                                    var ref1 = ref
                                        .collection('leaderboard')
                                        .doc(widget.data.get('uid'));

                                    //
                                    ref1.get().then((value) {
                                      if (value.exists) {
                                        var marks = value.get('marks');
                                        var newMarks = 0;
                                        // var add = marks + newObtainMark;
                                        if (newObtainMark != oldObtainMark) {
                                          newMarks = (marks - oldObtainMark) +
                                              newObtainMark;
                                        }
                                        //
                                        ref1.update({
                                          'marks': newMarks,
                                          'name': name,
                                          'uid': widget.data.get('uid'),
                                        });
                                      } else {
                                        ref1.set({
                                          'marks': newObtainMark,
                                          'name': name,
                                          'uid': widget.data.get('uid'),
                                        });
                                      }
                                    }).whenComplete(() {
                                      Navigator.pop(context);
                                    });
                                  });
                                }
                              },
                              child: const Text('Confirm'),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
