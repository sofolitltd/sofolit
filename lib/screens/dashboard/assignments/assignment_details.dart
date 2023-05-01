import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sofolit/utils/date_time_formatter.dart';

class AssignmentDetails extends StatefulWidget {
  const AssignmentDetails({super.key, required this.data, required this.uid});

  final String uid;
  final QueryDocumentSnapshot data;

  @override
  State<AssignmentDetails> createState() => _AssignmentDetailsState();
}

class _AssignmentDetailsState extends State<AssignmentDetails> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment'),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('courses')
                    .doc(widget.uid)
                    .collection('assignment')
                    .doc(widget.data.id)
                    .collection('subscribers')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                    );
                  }

                  var status = 'Pending';
                  int obtainMark = 0;
                  String feedback = '';
                  if (snapshot.data!.exists) {
                    status = snapshot.data!.get('status');
                    obtainMark = snapshot.data!.get('marks');
                    feedback = snapshot.data!.get('feedback');
                  }

                  //
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //title
                      Text(
                        widget.data.get('title'),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 8),

                      //des
                      Text(
                        widget.data.get('description'),
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
                        DTFormatter.dateTimeFormat(widget.data.get('time')),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 16),

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
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                status,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: status == 'Pending'
                                            ? Colors.orange.shade500
                                            : status == 'Submitted'
                                                ? Colors.blue.shade500
                                                : Colors.green.shade500),
                              ),
                            ],
                          ),

                          //marks
                          if (status == 'Approved')
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Mark',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  obtainMark.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                          height: 1,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                ),
                                Text(
                                  'out of ${widget.data.get('marks')}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        height: 1,
                                      ),
                                ),
                              ],
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      if (status == 'Approved' && feedback != '') ...[
                        Text(
                          'Teacher\'s Feedback',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          feedback ?? '',
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],

                      //link
                      if (status != 'Approved') ...[
                        Text(
                          'Assignment link',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
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
                          validator: (value) =>
                              value!.isEmpty ? 'Enter link' : null,
                        ),
                      ],

                      const SizedBox(height: 24),

                      //
                      ElevatedButton(
                        onPressed: status == 'Approved'
                            ? () => Navigator.pop(context)
                            : () async {
                                String userId =
                                    FirebaseAuth.instance.currentUser!.uid;
                                if (_globalKey.currentState!.validate()) {
                                  var ref = FirebaseFirestore.instance
                                      .collection('courses')
                                      .doc(widget.uid)
                                      .collection('assignment')
                                      .doc(widget.data.id)
                                      .collection('subscribers')
                                      .doc(userId);

                                  if (status == 'Pending') {
                                    await ref.set({
                                      'status': 'Submitted',
                                      'marks': obtainMark,
                                      'feedback': feedback,
                                      'url': _urlController.text.trim(),
                                    }).whenComplete(() {
                                      Navigator.pop(context);
                                      print('ok');
                                    });
                                  } else if (status == 'Submitted') {
                                    await ref.update({
                                      'status': status,
                                      'marks': obtainMark,
                                      'feedback': feedback,
                                      'url': _urlController.text.trim(),
                                    }).whenComplete(() {
                                      Navigator.pop(context);
                                      print('ok');
                                    });
                                  }
                                }
                              },
                        child: Text(
                          status == 'Pending'
                              ? 'Submit Now'.toUpperCase()
                              : status == 'Submitted'
                                  ? 'Submitted Again'.toUpperCase()
                                  : 'Got IT'.toUpperCase(),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
