import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_firebase_crud_project/constants.dart';
import 'package:flutter_firebase_crud_project/models/user_model.dart';
import 'package:flutter_firebase_crud_project/screens/home_page/home_screen.dart';
import 'package:flutter_firebase_crud_project/theme/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _firestore = FirebaseFirestore.instance;
User? googleLoggedInUser;
UserModel loggedInUser = UserModel();
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
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser!;
      googleLoggedInUser = user;
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
        leading: const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.transparent,
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
          //
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
          // ! Logout Button
          Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 8),
            child: IconButton(
              onPressed: () async {
                Navigator.pushNamed(context, HomeScreen.id);
              },
              icon: const Icon(Icons.logout),
              color: const Color(0xFF1cbb7c),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      String timeSent = "${DateTime.now()}";
                      _firestore.collection('messages').doc(timeSent).set({
                        'text': messageText,
                        'firstName': googleLoggedInUser!.displayName ??
                            loggedInUser.firstName,
                        'lastName': googleLoggedInUser!.displayName != null
                            ? ""
                            : loggedInUser.lastName,
                        'sender': googleLoggedInUser!.email,
                        'timeSent': timeSent,
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message['text'] ?? "";
          final messageSender = message['sender'] ?? "";
          final messageSenderFirstName = message['firstName'] ?? "";
          final messageSenderLastName = message['lastName'] ?? "";
          final messageTime = message['timeSent'] ?? "";

          final currentUser = googleLoggedInUser!.email;

          final messageBubble = MessageBubble(
            sender: "${messageSenderFirstName} ${messageSenderLastName}",
            text: messageText,
            isMe: currentUser == messageSender,
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.sender,
    required this.text,
    required this.isMe,
  }) : super(key: key);

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              sender,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.black54,
              ),
            ),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Color(0xFF1cbb7c) : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
