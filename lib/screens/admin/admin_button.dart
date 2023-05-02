import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminButton extends StatelessWidget {
  const AdminButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('admin')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        var data = snapshot.data!.docs;
        if (data.isEmpty) {
          return Container();
        }
        if (!snapshot.hasData) {
          return Container();
        }

        return FloatingActionButton(
          onPressed: onPressed,
          child: const Icon(Icons.add),
        );
      },
    );
  }
}
