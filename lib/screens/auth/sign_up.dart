import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/screens/auth/login.dart';
import '/screens/landing_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool inProgress = false;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Form(
        key: _globalKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: !isSmallScreen ? size.width * .2 : 16,
            vertical: 16,
          ),
          child: Container(
            color: Theme.of(context).cardColor,
            padding: EdgeInsets.symmetric(
              horizontal: !isSmallScreen ? 50 : 16,
              vertical: !isSmallScreen ? 50 : 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //name
                  const Text('Full Name'),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      border: OutlineInputBorder(),
                      hintText: 'Full name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter name';
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                  ),

                  const SizedBox(height: 16),

                  //mobile
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
                      if (value!.isEmpty) return 'Enter mobile';
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),
                  //
                  const Text('Email Address'),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      border: OutlineInputBorder(),
                      hintText: 'Email Address',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter email';
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  //
                  const Text('Password'),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      border: const OutlineInputBorder(),
                      hintText: '********',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() => _isObscure = !_isObscure);
                        },
                        icon: Icon(
                          _isObscure
                              ? Icons.visibility_off_outlined
                              : Icons.remove_red_eye_outlined,
                        ),
                      ),
                    ),
                    obscureText: _isObscure,
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter password';
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                  ),

                  //
                  const SizedBox(height: 24),

                  //sign up
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_globalKey.currentState!.validate()) {
                          try {
                            setState(() {
                              inProgress = true;
                            });
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            );

                            if (credential.user == null) return;

                            var ref = FirebaseFirestore.instance
                                .collection('users')
                                .doc(credential.user!.uid);

                            await ref.set({
                              'name': _nameController.text.trim(),
                              'mobile': _mobileController.text.trim(),
                              'email': _emailController.text.trim(),
                              'image': '',
                            }).then((value) {
                              setState(() {
                                inProgress = false;
                              });

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LandingPage()),
                                  (route) => false);
                            });
                            //
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              setState(() {
                                inProgress = false;
                              });
                              Fluttertoast.showToast(
                                  msg: 'The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              setState(() {
                                inProgress = false;
                              });
                              Fluttertoast.showToast(
                                  msg:
                                      'The account already exists for that email.');
                            }
                          } catch (e) {
                            setState(() {
                              inProgress = false;
                            });
                            Fluttertoast.showToast(msg: e.toString());
                          }
                        }
                      },
                      child: inProgress
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.white))
                          : const Text('Sign Up'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                        child: const Text(
                          'Login now.',
                          style: TextStyle(
                            color: Colors.transparent,
                            height: 1.5,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black,
                            shadows: [
                              Shadow(color: Colors.black, offset: Offset(0, -3))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
