import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_crud_project/models/user_model.dart';
import 'package:flutter_firebase_crud_project/provider/google_sign_in.dart';
import 'package:flutter_firebase_crud_project/screens/login_page/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crud_project/screens/search_screen.dart/search_screen.dart';
import 'package:flutter_firebase_crud_project/shared/loading.dart';
import 'package:flutter_firebase_crud_project/theme/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String id = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ! Handeling Image
  XFile? _image;
  String imagePath = "";
  String imageName = "";
  String? downloadURL;

  // ! Loading
  bool loading = false;

  final _formKey = GlobalKey<FormState>();
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
    // final updateButton = ;

    Future updateUserData(String fName, String lName) async {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(loggedInUser.uid)
          .update({'firstName': fName, 'lastName': lName});
    }

    // ! Media Query
    Size size = MediaQuery.of(context).size;

    String? userFirstName = loggedInUser.firstName ?? user!.displayName;
    String? userEmail = loggedInUser.email ?? user!.email;
    String? userProfileImageURL =
        user!.photoURL ?? loggedInUser.profileImagePath;

    // ! Scaffold UI
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pushNamed(context, SearchScreen.id);
                    });
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Color(0xFF1cbb7c),
                  ),
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
                      setState(() {
                        loading = true;
                      });
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.logout();
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
                            height: height * 0.53,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: height / 2.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: theme.focusColor == Colors.white
                                          ? Colors.grey.shade800
                                          : Colors.grey.shade200,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 100,
                                          ),
                                          Text(
                                            "${userFirstName ?? "Loading..."} ${loggedInUser.lastName ?? ""}",
                                            textAlign: TextAlign.center,
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
                                            // loggedInUser.email
                                            userEmail ?? "",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: theme.focusColor ==
                                                      Colors.white
                                                  ? Colors.grey.shade400
                                                  : Colors.black54,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),

                                          // ! Delete Button
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16.0),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  theme.focusColor ==
                                                          Colors.white
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
                                                      Navigator.pushNamed(
                                                          context,
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
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Text(
                                                  "deleteProfile".tr,
                                                  style: TextStyle(
                                                      color: theme.focusColor ==
                                                              Colors.white
                                                          ? Colors.red
                                                          : Colors
                                                              .grey.shade300,
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
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              if (_formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                updateUserData(
                                                                  newFirstNameController
                                                                      .text,
                                                                  newLastNameController
                                                                      .text,
                                                                );
                                                                Navigator
                                                                    .pushNamed(
                                                                  context,
                                                                  HomeScreen.id,
                                                                );
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      12.0),
                                                              child: Text(
                                                                "update".tr,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            18),
                                                              ),
                                                            ),
                                                            style: ButtonStyle(
                                                              shape:
                                                                  MaterialStateProperty
                                                                      .all(
                                                                RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                              ),
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(
                                                                const Color(
                                                                    0xFF1cbb7c),
                                                              ),
                                                            ),
                                                          ),
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
                                    color: const Color(0xFF1cbb7c)
                                        .withOpacity(0.8),
                                  ),
                                ),
                                Positioned(
                                  left: 10,
                                  right: 10,
                                  child: Center(
                                    child: CircleAvatar(
                                      backgroundColor: const Color(0xFF1cbb7c)
                                          .withOpacity(0.5),
                                      radius: 90,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(200),
                                        child: userProfileImageURL == null
                                            ? const Loading()
                                            : CachedNetworkImage(
                                                width: 150,
                                                height: 150,
                                                fit: BoxFit.cover,
                                                imageUrl: userProfileImageURL,
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(
                                                  strokeWidth: 4.0,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Loading(),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 140,
                                  right: 95,
                                  child: InkWell(
                                    onTap: () {
                                      _showSelectedImageDialog();
                                    },
                                    child: SizedBox(
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Colors.white.withOpacity(0.6),
                                        radius: size.width / 25.0,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0, bottom: 2),
                                            child: FaIcon(
                                              FontAwesomeIcons.edit,
                                              size: size.width / 22.5,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
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

  Future updateProfileImage(String filePath, String fileName, String uid,
      UserModel userModel, User user) async {
    File file = File(filePath);
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child(loggedInUser.uid!)
          .child(loggedInUser.uid!);
      await ref.putFile(file).then((TaskSnapshot taskSnapshot) {
        if (taskSnapshot.state == TaskState.success) {
          taskSnapshot.ref.getDownloadURL().then((downloadURL) {
            FirebaseFirestore.instance
                .collection("users")
                .doc(loggedInUser.uid)
                .update({"profileImagePath": downloadURL});
            Fluttertoast.showToast(msg: "Profile Image Updated!");
            loading = false;
            Navigator.pushNamed(context, HomeScreen.id);
          });
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Image could not be uploaded!");
    }
  }

  Function? _showSelectedImageDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text("Choose Photo"),
          actions: [
            _image == null
                ? const Icon(
                    Icons.account_circle_sharp,
                    size: 120,
                    color: Color(0xffcdd8dd),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 60,
                      child: _image == null
                          ? Image.asset('assets/images/transparent.png')
                          : Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFf3f3f3),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: FileImage(
                                    File(
                                      _image!.path,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
            CupertinoActionSheetAction(
              onPressed: () {
                _handleImage(source: ImageSource.camera);
              },
              child: const Text(
                "Take Photo",
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                _handleImage(source: ImageSource.gallery);
              },
              child: const Text(
                "Choose From Gallery",
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  _image = null;
                  imagePath = "";
                });
                Navigator.pop(context);
                _showSelectedImageDialog();
              },
              child: const Text(
                "Unselect Photo",
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                  loading = true;
                });
                updateProfileImage(imagePath, imageName, loggedInUser.uid!,
                    loggedInUser, user!);
              },
              child: const Text(
                "Upload Photo",
                style: TextStyle(color: Color(0xFF1cbb7c)),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  _handleImage({required ImageSource source}) async {
    Navigator.pop(context);
    XFile? imageFile = await ImagePicker().pickImage(source: source);
    if (imageFile != null) {
      setState(() {
        _image = imageFile;
        imagePath = _image!.path;
        imageName = _image!.name;
        _showSelectedImageDialog();
      });
    }
  }
}
