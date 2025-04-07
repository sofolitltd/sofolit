// login_dialog.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/auth/register.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _loginError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Login successful!");
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
        case 'too-many-requests':
          errorMessage =
              'Too many unsuccessful login attempts. Please try again later.';
        default:
          errorMessage = 'An error occurred during login: ${e.message}';
      }
      print(errorMessage);
      throw errorMessage;
    } catch (e) {
      final errorMessage = 'An unexpected error occurred: $e';
      print(errorMessage);
      throw errorMessage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Welcome to SOFOL IT',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Email Address',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            TextField(
              autofocus: true,
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            const Text(
              'Enter Password',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
              keyboardType: TextInputType.text,
            ),
            if (_loginError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _loginError!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 24),

            //
            Material(
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () async {
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();
                  if (email.isNotEmpty && password.isNotEmpty) {
                    setState(() {
                      _loginError = "Logging in...";
                    });
                    try {
                      await _loginWithEmail(email, password);
                      if (mounted) Navigator.pop(context);
                    } catch (e) {
                      if (mounted) {
                        setState(() {
                          _loginError = e.toString();
                        });
                      }
                    }
                  } else {
                    if (mounted) {
                      setState(() {
                        _loginError = 'Please enter both email and password.';
                      });
                    }
                  }
                },
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'এগিয়ে যান',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Assuming showRegisterDialog is in a different file and imported
                    showRegisterDialog(context);
                  },
                  child: Text(
                    "Create Account",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Function to show the dialog:
void showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const LoginDialog();
    },
  );
}

//
// rules_version = '2';
// service cloud.firestore {
// match /databases/{database}/documents {
// match /users/{userId} {
// allow create: if request.auth != null && request.auth.uid == userId;
// allow read, update, delete: if request.auth != null && request.auth.uid == userId;
// }
// }
// }
