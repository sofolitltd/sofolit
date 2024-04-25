import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sofolit/utils/date_time_formatter.dart';

enum AssignmentStatus { pending, submitted, approved }

class SubmitAssignment extends StatefulWidget {
  const SubmitAssignment({
    super.key,
    required this.courseID,
    required this.assignmentData,
  });

  final String courseID;
  final QueryDocumentSnapshot assignmentData;

  @override
  State<SubmitAssignment> createState() => _SubmitAssignmentState();
}

class _SubmitAssignmentState extends State<SubmitAssignment> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _urlController = TextEditingController();

  List submitterList = [];
  String submitterID = '';
  int obtainMark = 0;
  String feedback = '';
  String assignmentStatus = AssignmentStatus.pending.name;
  String currentUserID = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    submitterList = widget.assignmentData.get('submitterList');

    //
    for (var submitter in submitterList) {
      submitterID = submitter['submitterID'];
      if (submitterID == currentUserID) {
        obtainMark = submitter['obtainMark'];
        if (obtainMark == 0) {
          assignmentStatus = AssignmentStatus.submitted.name;
        } else {
          assignmentStatus = AssignmentStatus.approved.name;
        }
        feedback = submitter['feedback'].toString().isNotEmpty
            ? submitter['feedback']
            : 'Thank you for submit your assignment.';
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment'),
        centerTitle: isSmallScreen ? false : true,
        automaticallyImplyLeading: isSmallScreen ? false : true,
        actions: [
          if (isSmallScreen)
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.clear)),
        ],
      ),

      //
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).cardColor,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            margin: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: !isSmallScreen ? size.width * .2 : 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //title
                Text(
                  widget.assignmentData.get('assignmentTitle'),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                //des
                Text(
                  widget.assignmentData.get('assignmentDescription'),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 16),

                //deadline
                Text(
                  'Deadline',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  DTFormatter.dateWithTime(
                      widget.assignmentData.get('assignmentDate').toDate()),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),

                // status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // status
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          assignmentStatus.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  height: 1,
                                  fontWeight: FontWeight.bold,
                                  color: assignmentStatus ==
                                          AssignmentStatus.pending.name
                                      ? Colors.red.shade500
                                      : assignmentStatus ==
                                              AssignmentStatus.submitted.name
                                          ? Colors.orange.shade500
                                          : Colors.green.shade500),
                        ),
                      ],
                    ),

                    //marks
                    if (assignmentStatus == AssignmentStatus.approved.name)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Mark',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '$obtainMark',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      height: 1,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange,
                                    ),
                              ),
                              Text(
                                ' / ',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      height: 1,
                                      color: Colors.black54,
                                    ),
                              ),
                              Text(
                                '${widget.assignmentData.get('assignmentMarks')}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      height: 1,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                // feedback
                if (assignmentStatus == AssignmentStatus.approved.name)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        'Teacher\'s Feedback',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        feedback,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),

                //link
                if (assignmentStatus == AssignmentStatus.pending.name ||
                    assignmentStatus == AssignmentStatus.submitted.name) ...[
                  const Divider(),
                  const SizedBox(height: 4),

                  // guidelines
                  Text(
                    'Submission Guidelines',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '1. You can use social media / google drive links.\n2. For large file , upload your file on google drive and share that link(Anyone with the link)\n3. Submit assignments before deadline',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Submit Your Link',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 8),

                  //
                  TextFormField(
                    controller: _urlController,
                    maxLines: 5,
                    minLines: 1,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(16),
                      border: OutlineInputBorder(),
                      hintText: 'Link',
                      label: Text('link'),
                    ),
                    keyboardType: TextInputType.url,
                    validator: (value) => value!.isEmpty ? 'Enter link' : null,
                  ),

                  const SizedBox(height: 8),
                ],

                const SizedBox(height: 24),

//
                ElevatedButton(
                  onPressed: () async {
                    User user = FirebaseAuth.instance.currentUser!;

                    //
                    if (_globalKey.currentState!.validate()) {
                      var ref = FirebaseFirestore.instance
                          .collection('courses')
                          .doc(widget.courseID)
                          .collection('assignments')
                          .doc(widget.assignmentData.id);

                      if (assignmentStatus == AssignmentStatus.pending.name) {
                        // Remove existing entry for currentUserID
                        List updatedList = List.from(submitterList)
                          ..removeWhere((submitter) =>
                              submitter['submitterID'] == currentUserID);

                        // Add the new entry for currentUserID
                        updatedList.add({
                          'submitterID': currentUserID,
                          'obtainMark': 0,
                          'feedback': '',
                          'submittedLink': '',
                        });

                        // Update the Firestore document with the updated list
                        ref.update({
                          'submitterList': updatedList,
                        });
                      } else if (assignmentStatus ==
                          AssignmentStatus.submitted.name) {
                        // Update assignment link
                        await ref.update({
                          'submitterList': FieldValue.arrayRemove([
                            {
                              'submitterID': currentUserID,
                              'obtainMark': obtainMark,
                              'feedback': feedback,
                              'submittedLink': '', // Remove previous link
                            },
                          ]),
                        });
                        await ref.update({
                          'submitterList': FieldValue.arrayUnion([
                            {
                              'submitterID': currentUserID,
                              'obtainMark': 0,
                              'feedback': '',
                              'submittedLink': _urlController.text
                                  .trim(), // Update with new link
                            },
                          ]),
                        });
                      }
                    }
                    // Navigate back to the assignment page
                    Navigator.pop(context);
                  },
                  child: Text(
                    assignmentStatus == AssignmentStatus.pending.name
                        ? 'Submit Now'.toUpperCase()
                        : assignmentStatus == AssignmentStatus.submitted.name
                            ? 'Submit Again'.toUpperCase()
                            : 'Got IT'.toUpperCase(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
