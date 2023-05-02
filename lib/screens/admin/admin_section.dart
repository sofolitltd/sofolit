import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sofolit/screens/admin/admin_assignment.dart';

import '../payment.dart';

class AdminSection extends StatelessWidget {
  const AdminSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('admin')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 100,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
        var data = snapshot.data!.docs;
        if (data.isEmpty) {
          return Center(
            child: Container(),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        return Container(
          height: 150,
          color: Theme.of(context).cardColor,
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //head
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Text(
                  'Admin',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),

              // grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    //order
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Payment()));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 32),
                          child: Column(
                            children: [
                              const Icon(Icons.notifications_outlined),

                              //
                              Text(
                                'Order',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    //assignment
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AdminAssignment()));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 32),
                          child: Column(
                            children: [
                              const Icon(Icons.description_outlined),

                              //
                              Text(
                                'Assignment',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
