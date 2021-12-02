import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crud_project/screens/home_page/home_screen.dart';
import 'package:flutter_firebase_crud_project/screens/login_page/login_screen.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  static const String id = "splash_screen";

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToLoginScreen();
  }

  _navigateToLoginScreen() async {
    await Future.delayed(const Duration(milliseconds: 3000), () {});
    FirebaseAuth.instance.currentUser == null
        ? Navigator.pushNamed(context, LoginScreen.id)
        : Navigator.pushNamed(context, HomeScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Lottie.asset("assets/lottiefile/splash.json",
            width: 200, height: 200),
      ),
    );
  }
}
