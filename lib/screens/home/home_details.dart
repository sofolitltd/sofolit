import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sofolit/model/course_model.dart';

import '../../utils/date_time_formatter.dart';
import '../landing_page.dart';

class HomeDetails extends StatelessWidget {
  const HomeDetails({super.key, required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    //
    int remainingDays =
        course.enrollFinish.difference(course.enrollStart).inDays;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Course"),
      ),

      //
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: !isSmallScreen ? size.width * .2 : 0,
            vertical: !isSmallScreen ? 16 : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //title
                      Text(
                        course.courseTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                      ),

                      const SizedBox(height: 16),

                      // des
                      Text(
                        course.courseDescription,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                      ),

                      const SizedBox(height: 16),

                      //image
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              course.courseImage,
                            ),
                          ),
                          color: Colors.blue.shade100,
                        ),
                      ),

                      // seat, time
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            //time
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.watch_later_outlined,
                                      size: 20,
                                    ),

                                    const SizedBox(height: 4),

                                    //
                                    Text(
                                      remainingDays == 0
                                          ? 'On going'
                                          : '$remainingDays days remaining',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            //seat
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.people_outline,
                                      size: 20,
                                    ),

                                    const SizedBox(height: 4),

                                    //
                                    Text(
                                      '${course.courseSeats - course.enrolledStudents.length} seats left',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // schedule
                      Container(
                        decoration: BoxDecoration(
                          border: const Border(
                            left: BorderSide(color: Colors.amber, width: 5),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //batch
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.deepOrange.shade400,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${course.courseBatch} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),
                            ),

                            const Divider(),

                            // starting  day
                            Row(
                              children: [
                                Icon(
                                  Icons.watch_later_outlined,
                                  size: 18,
                                  color: Colors.deepOrange.shade400,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  ' Starting Time:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        height: 1.8,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 26),
                              child: Text(
                                '${DTFormatter.dateWithDay(course.classStartDate)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),

                            const Divider(),

                            // class day
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 16,
                                  color: Colors.deepOrange.shade400,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  ' Class Days:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        height: 2,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 26),
                              child: Column(
                                children:
                                    course.classSchedule.map((classSchedule) {
                                  return Text(
                                    classSchedule,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // todo: payment
                      if (remainingDays != 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Divider(),
                            Text(
                              '1. First send money to :01704340860\n(personal: bkash/rocket/nogod)'
                              '\n2. Click on the "Join Live Batch" and send your payment mobile number and transaction id'
                              '\n3. Then we will send a confirmation mail to your email.',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      // fontWeight: FontWeight.bold,
                                      ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // btn
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (remainingDays != 0)
                      //price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //discount
                          Text(
                            '৳ ${course.discountRate}',
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
                            '৳ ${course.coursePrice - (course.coursePrice * course.discountRate / 100).round()}',
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

                    if (remainingDays == 0)
                      const Text(
                        'Check out our upcoming batches',
                        style: TextStyle(
                          color: Colors.deepOrange,
                        ),
                      ),
                    const SizedBox(height: 8),

                    //
                    ElevatedButton(
                      onPressed: remainingDays == 0
                          ? null
                          : () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CompletePayment(course: course)));
                            },
                      child: Text(
                        remainingDays == 0
                            ? 'Enrollment Closed'
                            : 'Join Live Batch',
                        style: TextStyle(
                          color: remainingDays == 0 ? Colors.red : null,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// todo
// approvedUser(data) {
//   FirebaseFirestore.instance.collection('courses').doc(data.id).update({
//     'subscribers': [
//       FirebaseAuth.instance.currentUser!.uid,
//     ],
//   });
// }

//
class CompletePayment extends StatefulWidget {
  const CompletePayment({super.key, required this.course});

  final CourseModel course;

  @override
  State<CompletePayment> createState() => _CompletePaymentState();
}

class _CompletePaymentState extends State<CompletePayment> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _transactionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Payment'),
      ),

      //
      body: Form(
        key: _globalKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: !isSmallScreen ? size.width * .2 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: !isSmallScreen ? 50 : 0,
                      vertical: !isSmallScreen ? 50 : 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Mobile No'),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _mobileController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            border: OutlineInputBorder(),
                            hintText: 'Mobile No',
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) return 'Enter mobile no';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text('Transaction Id'),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _transactionController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            border: OutlineInputBorder(),
                            hintText: 'Transaction Id',
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) return 'Enter Transaction Id';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //total
                          Text(
                            'Total Payment',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                          ),

                          const SizedBox(width: 8),

                          //price
                          Text(
                            '৳ ${widget.course.coursePrice - (widget.course.coursePrice * widget.course.discountRate / 100).round()} ',
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

                      const SizedBox(height: 8),

                      //
                      ElevatedButton(
                        onPressed: () async {
                          if (_globalKey.currentState!.validate()) {
                            var user = FirebaseAuth.instance.currentUser;
                            await FirebaseFirestore.instance
                                .collection('payments')
                                .doc()
                                .set({
                              'userID': user!.uid,
                              'userEmail': user.email,
                              'orderId': FieldValue.increment(1),
                              'mobile': _mobileController.text.trim(),
                              'transaction': _transactionController.text.trim(),
                              'courseTitle': widget.course.courseTitle,
                              'courseBatch': widget.course.courseBatch,
                              'coursePrice': widget.course.coursePrice,
                              'enrollTime': DateTime.now(),
                              'status': 'pending',
                            }).then((value) {
                              Fluttertoast.showToast(
                                  msg:
                                      'Payment info submitted.\n We will send you a confirmation mail soon');
                              //
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LandingPage()),
                                  (route) => false);
                            });
                          }
                        },
                        child: const Text('Complete Payment'),
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
