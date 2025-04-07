import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/bkash/bkash_gateway.dart';
import '/bkash/models/payment_status.dart';

class PaymentScreen extends StatefulWidget {
  final String paymentID;
  final String status;
  final String slug;

  const PaymentScreen({
    super.key,
    required this.paymentID,
    required this.status,
    required this.slug,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false; // For showing the loading spinner
  String _message = ''; // Message to show during the payment process
  String _trxID = '';

  @override
  void initState() {
    super.initState();
    _handlePaymentStatus();
  }

  // Simulate backend API call
  Future<void> _processPayment() async {
    setState(() {
      _isLoading = true;
      _message = 'Your payment is on the way, don\'t close your window...';
    });

    // execute payment processing
    var grantTokenResponse =
        await BkashPaymentGateway(isProduction: false).grantToken();

    var executePayment =
        await BkashPaymentGateway(isProduction: false).executePayment(
      idToken: grantTokenResponse.idToken,
      paymentID: widget.paymentID,
    );

    // After payment processing
    setState(() {
      _isLoading = false;
      _message = executePayment.statusMessage;
      _trxID = executePayment.trxID;
    });

    // After processing, navigate to the course page or handle other business logic
    var user = FirebaseAuth.instance.currentUser!;

    // add orders
    FirebaseFirestore.instance.collection('orders').add({
      "uid": user.uid,
      "email": user.email,
      "time": executePayment.paymentExecuteTime,
      "number": executePayment.payerReference,
      "trxID": executePayment.trxID,
      "amount": executePayment.amount,
      "course": widget.slug,
    });

    //
    FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'courses': FieldValue.arrayUnion([widget.slug]),
    });
  }

  void _handlePaymentStatus() {
    if (widget.status == BkashPaymentStatus.success.name) {
      _processPayment();
    } else if (widget.status == BkashPaymentStatus.cancel.name) {
      setState(() {
        _isLoading = true;
      });
      _message = "Payment Canceled";
      Future.delayed(const Duration(seconds: 3)).then((val) {
        setState(() {
          _isLoading = false;
        });
        context.go('/courses/${widget.slug}');
      });
    } else if (widget.status == BkashPaymentStatus.failure.name) {
      setState(() {
        _isLoading = true;
      });
      _message = "Payment Failed";
      Future.delayed(const Duration(seconds: 3)).then((val) {
        setState(() {
          _isLoading = false;
        });
        context.go('/courses/${widget.slug}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Order Status for ${widget.slug}'),
      // ),

      body: _isLoading
          ? Center(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            )) // Show loading spinner
          : Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.green.shade50,
                      ),
                      CircleAvatar(radius: 40, backgroundColor: Colors.white),
                      //
                      Icon(
                        Icons.check_circle,
                        size: 120,
                        color: Colors.green,
                      ),
                    ],
                  ),

                  SizedBox(height: 32),
                  Text(
                    'Thank You',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Your Order is Confirmed'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),
                  //
                  Text('Course: ${widget.slug.replaceAll('-', ' ')}'
                      .toUpperCase()),

                  Text('Transaction ID: $_trxID'),
                  // Text('Status: ${widget.status}'),
                  //
                  const SizedBox(height: 32),

                  //
                  if (widget.status == BkashPaymentStatus.success.name)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        //
                        ElevatedButton(
                            onPressed: () {
                              //
                              context.go('/');
                            },
                            child: const Text('Go to Home')),
                        ElevatedButton(
                            onPressed: () {
                              //
                              context.go('/dashboard');
                            },
                            child: const Text('Go to Dashboard')),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}
