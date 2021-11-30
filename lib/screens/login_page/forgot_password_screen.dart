import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  static const String id = "forgot_password_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          Center(
            child: Text(
              "Forgot Password Screen",
            ),
          ),
        ],
      ),
    );
  }
}
