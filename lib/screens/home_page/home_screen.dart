import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase_crud_project/models/user_model.dart';
import 'package:flutter_firebase_crud_project/screens/login_page/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crud_project/shared/loading.dart';
import 'package:flutter_firebase_crud_project/theme/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String id = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ! Loading
  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  // final auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  final TextEditingController newFirstNameController = TextEditingController();
  final TextEditingController newLastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;

    // ! First Name Field
    final firstNameField = TextFormField(
      style: TextStyle(
        color: theme.focusColor == Colors.white ? Colors.white : Colors.black,
      ),
      cursorColor: const Color(0xFF1cbb7c),
      decoration: InputDecoration(
        labelText: "firstName".tr,
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
      controller: newFirstNameController,
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
      onSaved: (value) {
        newFirstNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );
    // ! Last Name Field
    final lastNameField = TextFormField(
      style: TextStyle(
        color: theme.focusColor == Colors.white ? Colors.white : Colors.black,
      ),
      cursorColor: const Color(0xFF1cbb7c),
      decoration: InputDecoration(
        labelText: "lastName".tr,
        floatingLabelStyle: const TextStyle(
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
      controller: newLastNameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return ("Please Enter Your Last Name");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter Valid Name (Minimum 2 Characters.)");
        }
        return null;
      },
      onSaved: (value) {
        newLastNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    // ! Update Button
    final updateButton = ElevatedButton(
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          "update".tr,
          style: const TextStyle(fontSize: 18),
        ),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          const Color(0xFF1cbb7c),
        ),
      ),
    );
    return loading
        ? const Loading()
        : Scaffold(
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
              title: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  "myProfile".tr,
                  style: const TextStyle(
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
                // ! Logout Button
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, right: 8),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        loading = true;
                      });
                      Navigator.pushNamed(context, LoginScreen.id);
                      FirebaseAuth.instance.signOut().then((value) => {
                            Fluttertoast.showToast(msg: "Logged Out!"),
                          });
                    },
                    icon: const Icon(Icons.logout),
                    color: const Color(0xFF1cbb7c),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 34),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            // decoration: BoxDecoration(color: Colors.grey),
                            height: height * 0.43,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: theme.focusColor == Colors.white
                                          ? Colors.grey.shade800
                                          : Colors.grey.shade200,
                                      // Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 80,
                                        ),
                                        Text(
                                          "${loggedInUser.firstName} ${loggedInUser.lastName}",
                                          style: const TextStyle(
                                            color: Color(0xFF1cbb7c),
                                            fontSize: 37,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "${loggedInUser.email}",
                                          style: TextStyle(
                                            color:
                                                theme.focusColor == Colors.white
                                                    ? Colors.grey.shade400
                                                    : Colors.black54,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),

                                        // ! Delete Button
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                theme.focusColor == Colors.white
                                                    ? Colors.grey.shade300
                                                    : Colors.red,
                                              ),
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                loading = true;
                                              });
                                              await FirebaseStorage.instance
                                                  .ref()
                                                  .child(loggedInUser.uid!)
                                                  .child(loggedInUser.uid!)
                                                  .delete()
                                                  .then((value) => {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Image Deleted!"),
                                                      });
                                              await FirebaseFirestore.instance
                                                      .collection("users")
                                                      .doc(loggedInUser.uid)
                                                      .delete()
                                                      .then((value) {
                                                    Navigator.pushNamed(context,
                                                        LoginScreen.id);
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Your Accout is Deleted!");
                                                  }) ??
                                                  '';
                                              await FirebaseAuth
                                                  .instance.currentUser!
                                                  .delete();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                "deleteProfile".tr,
                                                style: TextStyle(
                                                    color: theme.focusColor ==
                                                            Colors.white
                                                        ? Colors.red
                                                        : Colors.grey.shade300,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 110,
                                  right: 10,
                                  // ! Setting Button
                                  child: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (context) => Container(
                                          decoration: BoxDecoration(
                                            color:
                                                theme.focusColor == Colors.white
                                                    ? Colors.grey.shade900
                                                    : Colors.white,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                          // color: Color(0xFF737373),
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          child: Form(
                                            key: _formKey,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 16),
                                              child: Column(
                                                children: [
                                                  // ! First Name Field
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 16),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              theme.focusColor ==
                                                                      Colors
                                                                          .white
                                                                  ? Colors.grey
                                                                      .shade900
                                                                  : const Color(
                                                                      0x0fffffff),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: firstNameField,
                                                    ),
                                                  ),
                                                  // ! Last Name Field
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 16),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              theme.focusColor ==
                                                                      Colors
                                                                          .white
                                                                  ? Colors.grey
                                                                      .shade900
                                                                  : const Color(
                                                                      0x0fffffff),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: lastNameField,
                                                    ),
                                                  ),
                                                  // ! Update Button
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 16.0),
                                                          child: updateButton,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.settings,
                                      size: 30,
                                    ),
                                    color: const Color(0xFF1cbb7c),
                                  ),
                                ),
                                Positioned(
                                  top: 20,
                                  left: 10,
                                  right: 10,
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: loggedInUser.profileImagePath ==
                                              null
                                          ? const Loading()
                                          : CachedNetworkImage(
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.fitWidth,
                                              imageUrl: loggedInUser
                                                  .profileImagePath!,
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(
                                                strokeWidth: 4.0,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
