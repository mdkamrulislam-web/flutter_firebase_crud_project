import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  // *
  final googleSignIn = GoogleSignIn();
  // * Field for the user that has signed in
  GoogleSignInAccount? _user;
  // * Getter method for getting the google signed in account
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      // * Goolge Sign-in popup
      final googleUser = await googleSignIn.signIn();
      // * checking whether the user selected an account or not
      if (googleUser == null) return;
      // * saving the user in _user field if he/she has selected an account
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      await FirebaseFirestore.instance.collection("users").doc(user.id).set({
        "firstName": user.displayName,
        "lastName": "",
        "email": user.email,
        "uid": user.id,
        "profileImagePath": user.photoUrl,
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }

    notifyListeners();
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
