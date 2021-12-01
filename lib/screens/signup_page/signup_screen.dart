import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crud_project/models/user_model.dart';
import 'package:flutter_firebase_crud_project/screens/home_page/home_screen.dart';
import 'package:flutter_firebase_crud_project/shared/loading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_firebase_crud_project/screens/signup_page/terms_conditions_screen.dart';
import 'package:flutter_firebase_crud_project/theme/theme.dart';
import 'info_screen.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  static const String id = "signup_screen";

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // ! Password Visibility
  bool isHidden = true;

  // ! Loading
  bool loading = false;

  // ! Firebase Auth
  final auth = FirebaseAuth.instance;

  // ! Firebase Storage
  final FirebaseStorage storage = FirebaseStorage.instance;
  String? downloadURL;

  // ! Firebase Firestore
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // * Password Visibility Initialization
  bool _isHidden = true;
  bool _isConPassHidden = true;

  // * Importing Image or Taking Image
  XFile? _image;
  String imagePath = "";
  String imageName = "";

  // * Form Key
  final _formKey = GlobalKey<FormState>();

  // * Editing Controller
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    double textFormFieldPadding = 8;
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
      controller: firstNameController,
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
        firstNameController.text = value!;
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
      controller: lastNameController,
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
        lastNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );
    // ! Email Field
    final emailField = TextFormField(
      style: TextStyle(
        color: theme.focusColor == Colors.white ? Colors.white : Colors.black,
      ),
      cursorColor: const Color(0xFF1cbb7c),
      decoration: InputDecoration(
        labelText: "email".tr,
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
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter Your Email!";
        }
        //reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );
    // ! Password Field
    final passwordField = TextFormField(
      textInputAction: TextInputAction.next,
      style: TextStyle(
        color: theme.focusColor == Colors.white ? Colors.white : Colors.black,
      ),
      cursorColor: const Color(0xFF1cbb7c),
      obscureText: _isHidden,
      decoration: InputDecoration(
        labelText: "password".tr,
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
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: InkWell(
            onTap: () {
              setState(() {
                _isHidden = !_isHidden;
              });
            },
            child: Icon(
              _isHidden ? Icons.visibility_off : Icons.visibility,
              size: 20,
              color: _isHidden ? Colors.grey : const Color(0xFF1cbb7c),
            ),
          ),
        ),
      ),
      autofocus: false,
      controller: passwordController,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Please Enter Your Password");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter Valid Password (Minimum 6 Characters.)");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
    );
    // ! Confrim Password Field
    final confirmPassField = TextFormField(
      style: TextStyle(
        color: theme.focusColor == Colors.white ? Colors.white : Colors.black,
      ),
      cursorColor: const Color(0xFF1cbb7c),
      obscureText: _isHidden,
      decoration: InputDecoration(
        labelText: "confirmPass".tr,
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
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: InkWell(
            onTap: () {
              setState(() {
                _isConPassHidden = !_isConPassHidden;
              });
            },
            child: Icon(
              _isConPassHidden ? Icons.visibility_off : Icons.visibility,
              size: 20,
              color: _isHidden ? Colors.grey : const Color(0xFF1cbb7c),
            ),
          ),
        ),
      ),
      autofocus: false,
      controller: confirmPassController,
      validator: (value) {
        if (passwordController.text != value) {
          return "Passwords Don't Match";
        }
        return null;
      },
      onSaved: (value) {
        confirmPassController.text = value!;
      },
      textInputAction: TextInputAction.done,
    );

    return loading
        ? const Loading()
        : Scaffold(
            // ! App Bar
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 500,
              leading: Padding(
                padding: const EdgeInsets.only(top: 16.0, right: 8),
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      // ignore: avoid_print
                      print("Going Back!");
                      Navigator.pop(context);
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Color(0xFF1cbb7c),
                  ),
                  label: GestureDetector(
                    onTap: () {
                      setState(() {
                        // ignore: avoid_print
                        print("Going Back!");
                        Navigator.pop(context);
                      });
                    },
                    child: Text(
                      "back".tr,
                      style: const TextStyle(
                        color: Color(0xFF1ABB7B),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              title: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    "welcome".tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: theme.focusColor == Colors.white
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
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
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        // ignore: avoid_print
                        print("Showing Info!");
                        Navigator.pushNamed(context, InfoScreen.id);
                      });
                    },
                    child: Text(
                      "info".tr,
                      style: const TextStyle(
                        color: Color(0xFF1ABB7B),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 16, left: 16.0, right: 16.0),
                child: ListView(
                  children: [
                    Text(
                      "signUp".tr,
                      style: TextStyle(
                          fontSize: size.width / 12,
                          fontWeight: FontWeight.bold),
                    ),
                    // ? Setting Profile Photo
                    Center(
                      child: Stack(
                        children: [
                          _image == null
                              ? const Icon(
                                  Icons.account_circle_sharp,
                                  size: 120,
                                  color: Color(0xffcdd8dd),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 60,
                                  child: _image == null
                                      ? Image.asset(
                                          'assets/images/transparent.png')
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFf3f3f3),
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: FileImage(
                                                File(
                                                  _image!.path,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: InkWell(
                              onTap: () {
                                _showSelectedImageDialog();
                              },
                              child: SizedBox(
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: size.width / 25.0,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4.0, bottom: 2),
                                      child: FaIcon(
                                        FontAwesomeIcons.edit,
                                        size: size.width / 22.5,
                                        color: Colors.black,
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
                    SizedBox(
                      height: size.height / 60,
                    ),
                    // ? Signup Form
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            // ! First Name Field
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: textFormFieldPadding),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: theme.focusColor == Colors.white
                                        ? Colors.grey.shade900
                                        : const Color(0x0fffffff),
                                    borderRadius: BorderRadius.circular(10)),
                                child: firstNameField,
                              ),
                            ),
                            // ! Last Name Field
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: textFormFieldPadding),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: theme.focusColor == Colors.white
                                        ? Colors.grey.shade900
                                        : const Color(0x0fffffff),
                                    borderRadius: BorderRadius.circular(10)),
                                child: lastNameField,
                              ),
                            ),
                            // ! Email Field
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: textFormFieldPadding),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: theme.focusColor == Colors.white
                                        ? Colors.grey.shade900
                                        : const Color(0x0fffffff),
                                    borderRadius: BorderRadius.circular(10)),
                                child: emailField,
                              ),
                            ),
                            // ! Password Field
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: textFormFieldPadding),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: theme.focusColor == Colors.white
                                        ? Colors.grey.shade900
                                        : const Color(0x0fffffff),
                                    borderRadius: BorderRadius.circular(10)),
                                child: passwordField,
                              ),
                            ),
                            // ! Confirm Password Field
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: textFormFieldPadding),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: theme.focusColor == Colors.white
                                        ? Colors.grey.shade900
                                        : const Color(0x0fffffff),
                                    borderRadius: BorderRadius.circular(10)),
                                child: confirmPassField,
                              ),
                            ),
                            // ! Sign Up Button
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // ignore: avoid_print
                                        print(imagePath);
                                        if (_formKey.currentState!.validate() &&
                                            imagePath != "") {
                                          setState(() {
                                            loading = true;
                                          });
                                          signUp(emailController.text,
                                              passwordController.text);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              duration: Duration(seconds: 2),
                                              content: Text("Processing Data"),
                                            ),
                                          );
                                        } else {
                                          if (imagePath == "") {
                                            setState(() {
                                              loading = false;
                                            });
                                            Fluttertoast.showToast(
                                                msg: "No Photo was selected!");
                                          }
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          "continueToCreate".tr,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          const Color(0xFF1cbb7c),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // ! Terms & Conditions
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "iAgreeTo".tr,
                                    style: const TextStyle(
                                      color: Color(0xFF899cad),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // ignore: avoid_print
                                        print("Showing Terms and Conditions");
                                        Navigator.pushNamed(
                                            context, TermsConditionsScreen.id);
                                      });
                                    },
                                    child: Text(
                                      "termsConditions".tr,
                                      style: const TextStyle(
                                        color: Color(0xFF1cbb7c),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
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
          );
  }

  Function? _showSelectedImageDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text("Choose Photo"),
          actions: [
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
              },
              child: const Text(
                "Remove Photo",
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
      });
    }
  }

  Future signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                postDetailsToFirestore(),
              })
          .catchError((e) {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
          msg: errorMessage(
            e.toString(),
          ),
        );
      });
    }
  }

  String errorMessage(String? e) {
    if (e ==
        "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
      return "There is no user record corresponding to this identifier. The user may have been deleted.";
    } else if (e ==
        "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
      return "The password is invalid or the user does not have a password.";
    } else if (e ==
        "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
      return "The email address is already in use by another account.";
    } else {
      return "";
    }
  }

  Future postDetailsToFirestore() async {
    //Calling Firestore
    //Calling User Model
    //Sending Values

    User? user = auth.currentUser;

    UserModel userModel = UserModel();

    //Writing All The Values
    uploadProfileImage(_image!.path, _image!.name, user!.uid, userModel, user)
        as String?;
  }

  Future uploadProfileImage(String filePath, String fileName, String uid,
      UserModel userModel, User user) async {
    File file = File(filePath);
    try {
      Reference ref = storage.ref().child(uid).child(uid);
      await ref.putFile(file).then((TaskSnapshot taskSnapshot) {
        if (taskSnapshot.state == TaskState.success) {
          taskSnapshot.ref.getDownloadURL().then((downloadURL) {
            userModel.email = user.email;
            userModel.uid = user.uid;
            userModel.firstName = firstNameController.text;
            userModel.lastName = lastNameController.text;
            userModel.profileImagePath = downloadURL;
            firebaseFirestore.collection("users").doc(uid).set(
                  userModel.toMap(),
                );
            Navigator.pushNamed(context, HomeScreen.id);
            Fluttertoast.showToast(msg: "Signed Up Successfully!");
          });
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Image could not be uploaded!");
    }
  }
}
