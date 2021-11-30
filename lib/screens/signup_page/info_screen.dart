import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);
  static const String id = "info_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          Center(
            child: Text(
              "Info Screen",
            ),
          ),
        ],
      ),
    );
  }
}
