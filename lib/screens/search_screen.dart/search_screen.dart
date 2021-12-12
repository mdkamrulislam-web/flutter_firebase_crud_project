import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crud_project/screens/chat_screen/chat_screen.dart';
import 'package:flutter_firebase_crud_project/screens/user_profile/user_profile.dart';
import 'package:flutter_firebase_crud_project/theme/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  static const String id = 'search_screen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // ! Form Key
  final _formKey = GlobalKey<FormState>();

  late Map<String, dynamic> userMap = {};
  // ! Loading
  bool loading = false;

  // ! Text Field
  final TextEditingController _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: IconButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Color(0xFF1cbb7c),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            "Search User",
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
        ],
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.2,
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _search,
                  style: TextStyle(
                    color: theme.focusColor == Colors.white
                        ? Colors.white
                        : Colors.black,
                  ),
                  cursorColor: const Color(0xFF1cbb7c),
                  decoration: InputDecoration(
                    labelText: "Search",
                    floatingLabelStyle: const TextStyle(
                      //
                      color: Color(0xFF1cbb7c),
                      fontWeight: FontWeight.w600,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Color(0xFF1cbb7c),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    fillColor: theme.focusColor == Colors.white
                        ? Colors.grey.shade800
                        : const Color(0xFFf3f3f3),
                    filled: true,
                  ),
                  autofocus: false,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{2,}$');
                    if (value!.isEmpty) {
                      return ("Please Enter Your First Name");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Please Enter Valid Name (Minimum 2 Characters.)");
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xFF1cbb7c),
                  ),
                ),
                onPressed: () {
                  onSearch();
                },
                child: const Text(
                  "Search",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // ignore: unnecessary_null_comparison
              userMap['firstName'] != null
                  ? Container(
                      // height: 200,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            imageUrl: userMap['profileImagePath'] ??
                                "assets/images/youth.png",
                          ),
                        ),
                        title: Text(
                          "${userMap['firstName'] ?? ""} ${userMap['lastName'] ?? ""}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        subtitle: Text(
                          "${userMap["email"] ?? ""}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, ProfileScreen.id);
                        },
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, ChatScreen.id);
                          },
                          icon: const Icon(Icons.chat),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    setState(() {
      loading = true;
    });
    try {
      await _firestore
          .collection('users')
          .where("email", isEqualTo: _search.text)
          .get()
          .then((value) => {
                setState(() {
                  loading = true;
                }),
                userMap = value.docs[0].data(),
              });
    } catch (e) {
      if (e ==
          "RangeError (index): Invalid value: Valid value range is empty: 0") {
      } else if (_search != userMap['firstName'] && _search.text != "") {
        Fluttertoast.showToast(msg: "No user found!");
      } else if (_search.text == "") {
        Fluttertoast.showToast(msg: "Please enter an email address");
      }
      userMap = {};
      // print(e.toString());
    }
    // ignore: avoid_print
    print(userMap);
  }
}
