import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // User Registration
  Future createUser(
    String name,
    String empId,
    String email,
    String password,
  ) async {
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await firestore
          .collection('users')
          .doc(user.user.uid)
          .set({"name": name, "empId": empId, "email": email, "uid": user.user.uid, "approve": false});
      return 'account created';
    } catch (e) {
      return 'Error occurred';
    }
  }

  //User Login

  Future userSignIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Welcome';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else{
        return e.message;
      }
    }
  }

  // User Logout
  Future userLogOut() async {
    await auth.signOut();
  }
}

