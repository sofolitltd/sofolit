import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/screens/auth/login.dart';
import 'screens/landing_page.dart';

class WrapperScreen extends StatelessWidget {
  const WrapperScreen({super.key});
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const LandingPage();
        } else {
          return const Login();
        }
      },
    );
  }
}
