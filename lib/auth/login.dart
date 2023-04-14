import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/auth/forgot_password.dart';
import '/auth/sing_up.dart';
import '/screens/landing_page.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: size.width < 800
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Expanded(
                  flex: 2,
                  child: Div1(),
                ),
                Expanded(
                  flex: 3,
                  child: Div2(),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 1,
                  child: Div1(),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(size.width * .05),
                    child: const Div2(),
                  ),
                ),
              ],
            ),
    );
  }
}

class Div1 extends StatelessWidget {
  const Div1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple.shade300,
    );
  }
}

class Div2 extends StatefulWidget {
  const Div2({Key? key}) : super(key: key);

  @override
  State<Div2> createState() => _Div2State();
}

class _Div2State extends State<Div2> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalKey,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),

              const Text('Email Address'),
              const SizedBox(height: 4),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  border: OutlineInputBorder(),
                  hintText: 'Email address',
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Enter email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Password'),
              const SizedBox(height: 4),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  border: OutlineInputBorder(),
                  hintText: '********',
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Enter password';
                  return null;
                },
                obscureText: true,
              ),

              const SizedBox(height: 24),

              //login
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
                            .signInWithEmailAndPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        );

                        if (credential.user == null) return;

                        //
                        if (!mounted) return;
                        setState(() {
                          inProgress = false;
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LandingPage()),
                            (route) => false);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          Fluttertoast.showToast(
                              msg: 'No user found for that email.');
                          setState(() {
                            inProgress = false;
                          });
                        } else if (e.code == 'wrong-password') {
                          Fluttertoast.showToast(
                              msg: 'Wrong password provided for that user.');
                          setState(() {
                            inProgress = false;
                          });
                        }
                      }
                    }
                  },
                  child: inProgress
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white))
                      : const Text('Login'),
                ),
              ),

              const SizedBox(height: 16),

              // forgot pass
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPassword(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot password?',
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
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account?',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUp(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign up here.',
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
    );
  }
}
