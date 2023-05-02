import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sofolit/utils/date_time_formatter.dart';

class AssignmentDetails extends StatefulWidget {
  const AssignmentDetails({
    super.key,
    required this.data,
    required this.uid,
    required this.status,
    required this.feedback,
    required this.obtainMark,
    required this.totalMark,
  });

  final String uid;
  final String status;
  final String feedback;
  final int obtainMark;
  final int totalMark;
  final QueryDocumentSnapshot data;

  @override
  State<AssignmentDetails> createState() => _AssignmentDetailsState();
}

class _AssignmentDetailsState extends State<AssignmentDetails> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _urlController = TextEditingController();

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
                          widget.status,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: widget.status == 'Pending'
                                      ? Colors.orange.shade500
                                      : widget.status == 'Submitted'
                                          ? Colors.blue.shade500
                                          : Colors.green.shade500),
                        ),
                      ],
                    ),

                    //marks
                    if (widget.status == 'Approved')
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
                            '${widget.obtainMark}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    height: 1,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                          ),
                          Text(
                            'out of ${widget.totalMark}',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      height: 1,
                                    ),
                          ),
                        ],
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                if (widget.status == 'Approved' && widget.feedback != '') ...[
                  Text(
                    'Teacher\'s Feedback',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.feedback,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],

                //link
                if (widget.status != 'Approved') ...[
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
                    validator: (value) => value!.isEmpty ? 'Enter link' : null,
                  ),
                ],

                const SizedBox(height: 24),

                //
                ElevatedButton(
                  onPressed: widget.status == 'Approved'
                      ? () => Navigator.pop(context)
                      : () async {
                          User user = FirebaseAuth.instance.currentUser!;
                          //
                          if (_globalKey.currentState!.validate()) {
                            var ref = FirebaseFirestore.instance
                                .collection('courses')
                                .doc(widget.uid)
                                .collection('assignments')
                                .doc();

                            if (widget.status == 'Pending') {
                              await ref.set({
                                'uid': user.uid,
                                'email': user.email,
                                'assignmentId': widget.data.id,
                                'status': 'Submitted',
                                'totalMark': widget.data.get('marks'),
                                'obtainMark': 0,
                                'feedback': '',
                                'url': _urlController.text.trim(),
                              }).whenComplete(() {
                                Navigator.pop(context);
                                print('ok');
                              });
                            } else if (widget.status == 'Submitted') {
                              // todo: need check
                              await ref.update({
                                'uid': user.uid,
                                'email': user.email,
                                'assignmentId': widget.data.id,
                                'status': 'Submitted',
                                'totalMark': widget.data.get('marks'),
                                'obtainMark': 0,
                                'feedback': '',
                                'url': _urlController.text.trim(),
                              }).whenComplete(() {
                                Navigator.pop(context);
                                print('ok');
                              });
                            }
                          }
                        },
                  child: Text(
                    widget.status == 'Pending'
                        ? 'Submit Now'.toUpperCase()
                        : widget.status == 'Submitted'
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

//
//
// class AssignmentDetails extends StatefulWidget {
//   const AssignmentDetails({super.key, required this.data, required this.uid});
//
//   final String uid;
//   final QueryDocumentSnapshot data;
//
//   @override
//   State<AssignmentDetails> createState() => _AssignmentDetailsState();
// }
//
// class _AssignmentDetailsState extends State<AssignmentDetails> {
//   final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
//   final TextEditingController _urlController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     final isSmallScreen = size.width < 600;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Assignment'),
//         centerTitle: isSmallScreen ? false : true,
//         automaticallyImplyLeading: isSmallScreen ? false : true,
//         actions: [
//           if (isSmallScreen)
//             IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: const Icon(Icons.clear)),
//         ],
//       ),
//
//       //
//       body: SingleChildScrollView(
//         child: Form(
//           key: _globalKey,
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               color: Theme.of(context).cardColor,
//             ),
//             padding: const EdgeInsets.symmetric(
//               vertical: 16,
//               horizontal: 16,
//             ),
//             margin: EdgeInsets.symmetric(
//               vertical: 16,
//               horizontal: !isSmallScreen ? size.width * .2 : 16,
//             ),
//             child: StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('courses')
//                     .doc(widget.uid)
//                     .collection('assignments')
//                     .doc(FirebaseAuth.instance.currentUser!.uid)
//                     .collection('assignment')
//                     .doc(widget.data.id)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Container(
//                       padding: const EdgeInsets.all(10),
//                     );
//                   }
//
//                   if (!snapshot.hasData) {
//                     return Container(
//                       padding: const EdgeInsets.all(10),
//                     );
//                   }
//
//                   String status = 'Pending';
//                   String feedback = '';
//                   int? totalMark;
//                   int? obtainMark;
//                   if (snapshot.data!.exists) {
//                     status = snapshot.data!.get('status');
//                     feedback = snapshot.data!.get('feedback');
//                     totalMark = snapshot.data!.get('totalMark');
//                     obtainMark = snapshot.data!.get('obtainMark');
//                   }
//
//                   //
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       //title
//                       Text(
//                         widget.data.get('title'),
//                         style: Theme.of(context)
//                             .textTheme
//                             .titleLarge!
//                             .copyWith(fontWeight: FontWeight.bold),
//                       ),
//
//                       const SizedBox(height: 8),
//
//                       //des
//                       Text(
//                         widget.data.get('description'),
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodyLarge!
//                             .copyWith(fontWeight: FontWeight.w500),
//                       ),
//
//                       const SizedBox(height: 16),
//
//                       //deadline
//                       Text(
//                         'Deadline',
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodyMedium!
//                             .copyWith(fontWeight: FontWeight.w500),
//                       ),
//                       Text(
//                         DTFormatter.dateTimeFormat(widget.data.get('time')),
//                         style: Theme.of(context)
//                             .textTheme
//                             .titleLarge!
//                             .copyWith(fontWeight: FontWeight.bold),
//                       ),
//
//                       const SizedBox(height: 16),
//
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // status
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Status',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyMedium!
//                                     .copyWith(fontWeight: FontWeight.w500),
//                               ),
//                               Text(
//                                 status,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .headlineSmall!
//                                     .copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     color: status == 'Pending'
//                                         ? Colors.orange.shade500
//                                         : status == 'Submitted'
//                                         ? Colors.blue.shade500
//                                         : Colors.green.shade500),
//                               ),
//                             ],
//                           ),
//
//                           //marks
//                           if (status == 'Approved')
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   'Mark',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyMedium!
//                                       .copyWith(fontWeight: FontWeight.w500),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   obtainMark.toString(),
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .headlineSmall!
//                                       .copyWith(
//                                       height: 1,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black87),
//                                 ),
//                                 Text(
//                                   'out of $totalMark',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodySmall!
//                                       .copyWith(
//                                     fontWeight: FontWeight.w500,
//                                     height: 1,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 16),
//
//                       if (status == 'Approved' && feedback != '') ...[
//                         Text(
//                           'Teacher\'s Feedback',
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleMedium!
//                               .copyWith(fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           feedback,
//                           style:
//                           Theme.of(context).textTheme.titleSmall!.copyWith(
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//
//                       //link
//                       if (status != 'Approved') ...[
//                         Text(
//                           'Assignment link',
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyMedium!
//                               .copyWith(fontWeight: FontWeight.w500),
//                         ),
//                         const SizedBox(height: 8),
//                         TextFormField(
//                           controller: _urlController,
//                           maxLines: 5,
//                           minLines: 1,
//                           decoration: const InputDecoration(
//                             contentPadding: EdgeInsets.all(16),
//                             border: OutlineInputBorder(),
//                             hintText: 'Link',
//                             label: Text('link'),
//                           ),
//                           keyboardType: TextInputType.url,
//                           validator: (value) =>
//                           value!.isEmpty ? 'Enter link' : null,
//                         ),
//                       ],
//
//                       const SizedBox(height: 24),
//
//                       //
//                       ElevatedButton(
//                         onPressed: status == 'Approved'
//                             ? () => Navigator.pop(context)
//                             : () async {
//                           String userId =
//                               FirebaseAuth.instance.currentUser!.uid;
//                           //
//                           if (_globalKey.currentState!.validate()) {
//                             var ref = FirebaseFirestore.instance
//                                 .collection('courses')
//                                 .doc(widget.uid)
//                                 .collection('assignments')
//                                 .doc();
//
//                             if (status == 'Pending') {
//                               await ref.set({
//                                 'uid': userId,
//                                 'assignmentId': widget.data.id,
//                                 'status': 'Submitted',
//                                 'totalMark': widget.data.get('marks'),
//                                 'obtainMark': 0,
//                                 'feedback': feedback,
//                                 'url': _urlController.text.trim(),
//                               }).whenComplete(() {
//                                 Navigator.pop(context);
//                                 print('ok');
//                               });
//                             } else if (status == 'Submitted') {
//                               await ref.update({
//                                 'status': status,
//                                 'marks': obtainMark,
//                                 'feedback': feedback,
//                                 'url': _urlController.text.trim(),
//                               }).whenComplete(() {
//                                 Navigator.pop(context);
//                                 print('ok');
//                               });
//                             }
//                           }
//                         },
//                         child: Text(
//                           status == 'Pending'
//                               ? 'Submit Now'.toUpperCase()
//                               : status == 'Submitted'
//                               ? 'Submit Again'.toUpperCase()
//                               : 'Got IT'.toUpperCase(),
//                         ),
//                       ),
//                     ],
//                   );
//                 }),
//           ),
//         ),
//       ),
//     );
//   }
// }
