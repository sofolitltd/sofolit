import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  // todo: google
  // Future signInWithGoogle() async {
  //   //begin sign in process
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   //obtain auth details
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser!.authentication;
  //
  //   //create new credential for user
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //
  //   //lets sign in
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  // create
  static Future createAccountWithEmail(
      {required String email, required String password}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

// login
  static Future loginWithEmail(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (credential.user == null) return;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
