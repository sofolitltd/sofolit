import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/screens/courses/modules/assignment/assignment_submit.dart';

class AssignmentsCheck extends StatelessWidget {
  const AssignmentsCheck({
    super.key,
    required this.courseID,
  });

  final String courseID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Assignments'),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('courses')
              .doc(courseID)
              .collection('assignments')
              .orderBy('moduleNo', descending: true)
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
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemCount: data.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1080),
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.width > 600 ? 32 : 0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          //
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CheckAssignmentsDetails(
                                      courseID: courseID,
                                      assignmentData: data[index])));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                    'Module ${data[index].get('moduleNo')} - Class ${data[index].get('classNo')}'),
                                Text(data[index].get('assignmentTitle')),
                                Text(data[index]
                                    .get('assignmentMarks')
                                    .toString()),
                                Text(
                                    'Total submit: ${data[index].get('submitterList').length}'),
                              ],
                            )),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}

class CheckAssignmentsDetails extends StatelessWidget {
  const CheckAssignmentsDetails(
      {super.key, required this.courseID, required this.assignmentData});

  final String courseID;
  final QueryDocumentSnapshot assignmentData;

  @override
  Widget build(BuildContext context) {
    List submitterList = assignmentData.get('submitterList');

    //
    return Scaffold(
      appBar: AppBar(
        title: Text(assignmentData.get('assignmentTitle')),
      ),
      body: ListView.separated(
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemCount: submitterList.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            //
            return Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1080),
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > 600 ? 32 : 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    print(assignmentData.reference);
                    //
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssignmentsAssess(
                            courseID: courseID,
                            assignmentData: assignmentData,
                            submitterIndex: submitterList[index],
                          ),
                        ));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('${submitterList[index]['submitterID']}'),
                          Text('${submitterList[index]['submittedLink']}'),
                          Text(submitterList[index]['obtainMark'] == 0
                              ? AssignmentStatus.pending.name
                              : AssignmentStatus.approved.name),
                        ],
                      )),
                ),
              ),
            );
          }),
    );
  }
}

class AssignmentsAssess extends StatefulWidget {
  const AssignmentsAssess({
    super.key,
    required this.courseID,
    required this.assignmentData,
    required this.submitterIndex,
  });

  final String courseID;
  final QueryDocumentSnapshot assignmentData;
  final submitterIndex;

  @override
  State<AssignmentsAssess> createState() => _AssignmentsAssessState();
}

class _AssignmentsAssessState extends State<AssignmentsAssess> {
  String? _selectedStatus;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _totalMarkController = TextEditingController();
  final TextEditingController _obtainMarkController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    _totalMarkController.text =
        widget.assignmentData['assignmentMarks'].toString();
    _feedbackController.text = widget.submitterIndex['feedback'];

    if (widget.submitterIndex['obtainMark'] == 0) {
      _selectedStatus = 'Pending';
    } else {
      _obtainMarkController.text =
          widget.submitterIndex['obtainMark'].toString();
      _selectedStatus = 'Approved';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      //
      body: //
          SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1080),
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 600 ? 32 : 0,
                vertical: 16,
              ),
              // margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),

                  //
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                            controller: _obtainMarkController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder(),
                              hintText: 'Obtain Marks',
                              label: Text('Obtain Marks'),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter mark';
                              } else {
                                int? enteredMark = int.tryParse(value);
                                int? totalMarks =
                                    int.tryParse(_totalMarkController.text);
                                if (enteredMark == null) {
                                  return 'Enter valid number';
                                } else if (totalMarks == null) {
                                  return 'Total marks should be a valid number';
                                } else if (enteredMark > totalMarks) {
                                  return 'Entered mark should be less than total marks';
                                }
                              }
                              return null;
                            }),
                      ),

                      const Padding(
                        padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
                        child: Text('out of'),
                      ),

                      //
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _totalMarkController,
                          readOnly: true,
                          enabled: false,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(12),
                            border: OutlineInputBorder(),
                            hintText: 'Total Marks',
                            label: Text('Total Marks'),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value!.isEmpty ? 'Enter mark' : null,
                        ),
                      ),
                    ],
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
                    minLines: 2,
                    maxLines: 4,
                    // validator: (value) =>
                    //     value!.isEmpty ? 'Enter feedback' : null,
                  ),

                  const SizedBox(height: 16),

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
                              items: ['pending', 'approved']
                                  .map((status) => DropdownMenuItem<String>(
                                        value: StringUtils.capitalize(status),
                                        child: Text(
                                            StringUtils.capitalize(status)),
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
                      _selectedStatus == 'Pending'
                          ? Container()
                          : ElevatedButton(
                              onPressed: () async {
                                if (_globalKey.currentState!.validate()) {
                                  //
                                  // (courses/rcXlRm9PsAJGyZL2U0me/assignments/1714020591195)
                                  var ref = widget.assignmentData.reference;
                                  var submitterID =
                                      widget.submitterIndex['submitterID'];

                                  var updateData = {
                                    "feedback": _feedbackController.text ?? "",
                                    "obtainMark": int.tryParse(
                                            _obtainMarkController.text) ??
                                        0,
                                  };

                                  // Check if submitterID exists in submitterList
                                  //                                 bool submitterExists = false;
                                  List<dynamic> submitterList = List.from(
                                      widget.assignmentData['submitterList']);

                                  for (var i = 0;
                                      i < submitterList.length;
                                      i++) {
                                    if (submitterList[i]['submitterID'] ==
                                        submitterID) {
                                      // submitterExists = true;
                                      // Update existing entry
                                      submitterList[i]['feedback'] =
                                          updateData['feedback'];
                                      submitterList[i]['obtainMark'] =
                                          updateData['obtainMark'];
                                      break;
                                    }
                                  }

                                  // if (!submitterExists) {
                                  //   // If submitterID does not exist, add a new entry
                                  //   submitterList.add({
                                  //     "submitterID": submitterID,
                                  //     ...updateData,
                                  //   });
                                  // }

                                  // Update submitterList in Firestore
                                  ref.update({
                                    "submitterList": submitterList
                                  }).then((_) async {
                                    print("Data updated successfully");

                                    var ref2 = FirebaseFirestore.instance
                                        .collection('courses')
                                        .doc(widget.courseID)
                                        .collection('leaderboard')
                                        .doc(submitterID);

                                    await ref2
                                        .set({"submitterID": submitterID}).then(
                                            (value) async {
                                      await ref2
                                          .collection('assignments')
                                          .doc(widget.assignmentData.id)
                                          .set({
                                        "assignmentID":
                                            widget.assignmentData.id,
                                        "obtainMark": updateData['obtainMark'],
                                      });

                                      //
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    });
                                  }).catchError((error) {
                                    print("Error updating data: $error");
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
