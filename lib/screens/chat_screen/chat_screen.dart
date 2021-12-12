import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crud_project/theme/theme.dart';

User? loggedInUser;
User? user = FirebaseAuth.instance.currentUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  const ChatScreen({Key? key}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String? messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser!;
      loggedInUser = user;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: IconButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Color(0xFF1cbb7c),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            "Group Chat",
            style: TextStyle(
              color: Color(0xFF1cbb7c),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: IconButton(
              splashRadius: 20,
              icon: Icon(
                Icons.brightness_4_rounded,
                color: theme.focusColor,
              ),
              onPressed: () {
                currentTheme.toggleTheme();
              },
            ),
          ),
          // ! Back Button
        ],
      ),
      body: const SafeArea(
        child: Text("acascas"),
      ),
    );
  }
}
