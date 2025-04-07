import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/auth/login.dart';

class RegisterDialog extends StatefulWidget {
  const RegisterDialog({super.key});

  @override
  State<RegisterDialog> createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _registrationError;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Create a New Account',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          //
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
          spacing: 16,
          children: [
            //
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Enter your name',
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
            TextField(
              controller: _mobileController,
              decoration: const InputDecoration(
                hintText: 'Enter mobile number',
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),

            //
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Enter email address',
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

            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Enter strong password',
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
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
            ),
            if (_registrationError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _registrationError!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            const Text(
              "* Please remember this email and password for further login.",
              style: TextStyle(color: Colors.red),
            ),

            //
            const SizedBox(height: 4),

            //
            Material(
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () async {
                  String name = _nameController.text.trim();
                  String mobile = _mobileController.text.trim();
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();
                  if (name.isNotEmpty &&
                      mobile.isNotEmpty &&
                      email.isNotEmpty &&
                      password.isNotEmpty) {
                    try {
                      _createUserWithEmailAndPassword(
                        name,
                        mobile,
                        email,
                        password,
                      );

                      if (mounted) {
                        //Check if the widget is still in the tree
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Registration successful!'),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        setState(() {
                          _registrationError = e.toString();
                        });
                      }
                    }
                  } else {
                    if (mounted) {
                      setState(() {
                        _registrationError =
                            'Please fill in all registration fields.';
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
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            //
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    //
                    showLoginDialog(context);
                  },
                  child: const Text(
                    "Login",
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

Future<void> _createUserWithEmailAndPassword(
  String name,
  String mobile,
  String email,
  String password,
) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    // Save additional user data to Firestore:
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
          'name': name,
          'mobile': mobile,
          'email': email,
          'image': '',
          'courses': [],
        });
    print("Account created successfully!");
  } on FirebaseAuthException catch (e) {
    String errorMessage = "An error occurred during registration.";
    if (e.code == 'weak-password') {
      errorMessage = 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      errorMessage = 'The account already exists for that email.';
    } else if (e.code == 'invalid-email') {
      errorMessage = 'The email address is not valid.';
    }
    print(errorMessage); // For debugging - replace with user feedback
    throw errorMessage; // Rethrow to handle in the UI
  } on FirebaseException catch (e) {
    String errorMessage =
        "A Firestore error occurred: ${e.message ?? 'Unknown error'}";
    print(errorMessage);
    throw errorMessage;
  } catch (e) {
    String errorMessage = 'An unexpected error occurred: $e';
    print(errorMessage);
    throw errorMessage;
  }
}

// Function to show the dialog:
void showRegisterDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const RegisterDialog();
    },
  );
}
