import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crud_project/screens/home_page/home_screen.dart';
import 'package:flutter_firebase_crud_project/screens/login_page/login_screen.dart';
import 'package:flutter_firebase_crud_project/shared/loading.dart';

class GoogleSignInVerify extends StatelessWidget {
  const GoogleSignInVerify({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loading();
              } else if (snapshot.hasData) {
                return const HomeScreen();
              } else if (snapshot.hasError) {
                return const Center(child: Text("Something went wrong!"));
              } else {
                return const LoginScreen();
              }
            }),
      );
}
