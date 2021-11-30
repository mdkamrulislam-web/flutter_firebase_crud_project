import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({Key? key}) : super(key: key);
  static const String id = "terms_conditions_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          Center(
            child: Text(
              "Terms & Conditions Screen",
            ),
          ),
        ],
      ),
    );
  }
}
