import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/date_time_formatter.dart';
import '../landing_page.dart';

class HomeDetails extends StatelessWidget {
  const HomeDetails({Key? key, required this.data}) : super(key: key);

  final QueryDocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(data.get('title')),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //title
                      Text(
                        data.get('title'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontSize: 28,
                              height: 1.3,
                            ),
                      ),

                      const SizedBox(height: 16),

                      // des
                      Text(
                        data.get('description'),
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
                              data.get('image'),
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
                                    //todo:
                                    Text(
                                      '${DTFormatter.dayFormat(data.get('lastDate'))} Days Remaining',
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
                                      '${data.get('seat')} Seats Left',
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
                      Row(
                        children: [
                          Container(
                            width: 2,
                            height: 175,
                            color: Colors.deepOrange.shade400,
                          ),

                          const SizedBox(width: 16),

                          //
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //batch
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange.shade400,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  data.get('batch'),
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
                                    size: 20,
                                    color: Colors.deepOrange.shade400,
                                  ),
                                  const Text(' Starting Time:  '),
                                  Text(
                                    '${DTFormatter.dateFormat(data.get('startDate'))}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),

                              const Divider(),

                              // class day
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 20,
                                    color: Colors.deepOrange.shade400,
                                  ),
                                  const Text(' Class Days:  '),
                                  Text(
                                    '${data.get('classDay')}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),

                              const Divider(),

                              // class time
                              Row(
                                children: [
                                  Icon(
                                    Icons.watch_later_outlined,
                                    size: 20,
                                    color: Colors.deepOrange.shade400,
                                  ),
                                  const Text(' Class Time:  '),
                                  Text(
                                    '${data.get('classTime')}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      //head
                      Text(
                        'Payment',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),

                      const Divider(),
                      Text(
                        '1. First send money to :01704340860\n(personal: bkash/rocket/nogod)'
                        '\n2. Click on the "Join Live Batch" and send your payment mobile number and transaction id'
                        '\n3. Then we will send a confirmation mail to your email.',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                // fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // btn
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        //discount
                        Text(
                          '৳ ${data.get('price')}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.deepOrange.shade400,
                                    height: 1.3,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                        ),

                        const SizedBox(width: 8),

                        //price
                        Text(
                          '৳ ${data.get('price') - (data.get('price') * (data.get('discount') / 100)).round()}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    height: 1.3,
                                  ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    //
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CompletePayment(data: data)));
                      },
                      child: const Text('Join Live Batch'),
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
approvedUser(data) {
  FirebaseFirestore.instance.collection('courses').doc(data.id).update({
    'subscribers': [
      FirebaseAuth.instance.currentUser!.uid,
    ],
  });
}

class CompletePayment extends StatefulWidget {
  const CompletePayment({Key? key, required this.data}) : super(key: key);

  final QueryDocumentSnapshot data;

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
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  color: Theme.of(context).cardColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mobile No'),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _mobileController,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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

              const SizedBox(height: 10),

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
                            '৳ ${widget.data.get('price') - (widget.data.get('price') * (widget.data.get('discount') / 100)).round()} ',
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
                                .collection('payment')
                                .doc()
                                .set({
                              'uid': user!.uid,
                              'orderId': FieldValue.increment(1),
                              'email': user.email,
                              'price': widget.data.get('price'),
                              'mobile': _mobileController.text.trim(),
                              'transaction': _transactionController.text.trim(),
                              'courseId': widget.data.id,
                              'courseTitle': widget.data.get('title'),
                              'batch': widget.data.get('batch'),
                              'status': 'pending',
                            }).then((value) {
                              Fluttertoast.showToast(
                                  msg:
                                      'Payment info submitted.\nWe will send you a confirmation mail soon');
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
