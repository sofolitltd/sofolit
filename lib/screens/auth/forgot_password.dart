import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/repo.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailField = TextEditingController();
  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot password',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),

      //
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: !isSmallScreen ? size.width * .2 : 16,
          vertical: 16,
        ),
        child: Container(
          color: Theme.of(context).cardColor,
          padding: EdgeInsets.symmetric(
            horizontal: !isSmallScreen ? 50 : 0,
            vertical: !isSmallScreen ? 50 : 0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                //notice
                Text(
                  '* Check your mail box for reset mail.'
                  '\n* If mail not in mailbox, please check on spam folder.',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.black,
                      ),
                ),

                const SizedBox(height: 16),

                //
                TextFormField(
                  controller: _emailField,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return AppRepo.kEnterYourEmail;
                    } else if (!regExp.hasMatch(val)) {
                      return AppRepo.kEnterValidEmail;
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: AppRepo.kEmailHint,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 24),

                //
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);

                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(
                                      email: _emailField.text.trim())
                                  .then((value) {
                                //
                                Fluttertoast.showToast(
                                    msg:
                                        'Password reset email sent to your email');

                                setState(() => _isLoading = false);
                              });

                              //
                              if (!mounted) return;
                              Navigator.pop(context);

                              //
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content:
                                          Text('No user found for this email'),
                                    ),
                                  );

                                //
                                setState(() => _isLoading = false);
                              }
                            }
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Reset Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
