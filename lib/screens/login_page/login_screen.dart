import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crud_project/screens/home_page/home_screen.dart';
import 'package:flutter_firebase_crud_project/screens/login_page/forgot_password_screen.dart';
import 'package:flutter_firebase_crud_project/screens/signup_page/signup_screen.dart';
import 'package:flutter_firebase_crud_project/shared/loading.dart';
import 'package:flutter_firebase_crud_project/theme/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flag/flag.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ! Loading
  bool loading = false;

  // ! Firebase Auth
  final auth = FirebaseAuth.instance;

  final List locale = [
    {
      'name': 'English',
      'locale': const Locale('en', 'US'),
      'flag': const Flag.fromString('US', height: 30, width: 80),
    },
    {
      'name': 'বাংলা',
      'locale': const Locale('bn', 'BD'),
      'flag': const Flag.fromString('BD', height: 30, width: 80),
    },
  ];

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  String langauge = 'English';

  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  buildDialog(BuildContext) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: const Text('Choose Your Language'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GestureDetector(
                      onTap: () {
                        langauge = locale[index]['name'];
                        updateLanguage(locale[index]['locale']);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(locale[index]['name']),
                          locale[index]['flag'],
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Color(0xFF1cbb7c),
                  );
                },
                itemCount: locale.length,
              ),
            ),
          );
        });
  }

  // * Password Visibility Initialization
  bool _isHidden = true;

  // *Form Key
  final _formKey = GlobalKey<FormState>();

  // * Editing Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    double textFormFieldPadding = 8;
    // ! Email Field
    final emailField = TextFormField(
      style: TextStyle(
        color: theme.focusColor == Colors.white ? Colors.white : Colors.black,
      ),
      cursorColor: const Color(0xFF1cbb7c),
      decoration: InputDecoration(
        labelText: 'email'.tr,
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
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-zA-Z]")
            .hasMatch(value)) {
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
      style: TextStyle(
        color: theme.focusColor == Colors.white ? Colors.white : Colors.black,
      ),
      cursorColor: const Color(0xFF1cbb7c),
      obscureText: _isHidden,
      decoration: InputDecoration(
        labelText: "password".tr,
        floatingLabelStyle: const TextStyle(
          // ignore: prefer_const_constructors
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
              _togglePasswordVisibility();
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
      textInputAction: TextInputAction.next,
    );
    // ! Login Button
    final loginButton = ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          setState(() {
            loading = true;
          });
          signIn(emailController.text, passwordController.text);
          // setState(() {
          //   loading = false;
          // });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Processing Data"),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'signIn'.tr,
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
    // ! Sign Up Button
    final signUpButton = ElevatedButton(
      onPressed: () {
        // ignore: avoid_print
        print("Signing Up!");

        Navigator.pushNamed(context, SignupScreen.id);
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          "signUp".tr,
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
          const Color(0xFF899cad),
        ),
      ),
    );
    // ! Sign Up with Google Button
    final signUpWithGoogleButton = ElevatedButton(
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "signInGoogle".tr,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              width: 10,
            ),
            const Image(
              height: 20,
              image: AssetImage(
                "assets/images/google.png",
              ),
            ),
          ],
        ),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          const Color(0xFF899cad).withOpacity(0.4),
        ),
      ),
    );
    return loading
        ? const Loading()
        : Scaffold(
            // ! App Bar
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              toolbarHeight: 50.0,
              elevation: 0,
              leadingWidth: 200,
              leading: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () {
                    buildDialog(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.language,
                          color: Color(0xFF1cbb7c),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          langauge,
                          style: const TextStyle(
                            color: Color(0xFF1cbb7c),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 16.0),
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
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                ),
                child: SizedBox(
                  height: size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 00.0),
                              child: Text(
                                'welcome'.tr,
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              'toApplication'.tr,
                              style: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
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
                            // ! Login Button
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 24.0),
                                    child: loginButton,
                                  ),
                                ),
                              ],
                            ),
                            // ! Sign Up With Google Button
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: signUpWithGoogleButton,
                            ),
                            // ! Forget Password
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    // ignore: avoid_print
                                    print("Showing Forgot Password Options");
                                    Navigator.pushNamed(
                                        context, ForgotPasswordScreen.id);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Text(
                                    "forgotPass".tr,
                                    style: const TextStyle(
                                      color: Color(0xFF1cbb7c),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ! Sign Up Button
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: signUpButton,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Future signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Logged In Successfully"),
                Navigator.pushNamed(context, HomeScreen.id),
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

  errorMessage(String e) {
    if (e ==
        "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
      return "There is no user record corresponding to this identifier. The user may have been deleted.";
    } else if (e ==
        "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
      return "The password is invalid or the user does not have a password.";
    } else if (e ==
        "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
      return "The email address is already in use by another account.";
    } else if (e ==
        "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.") {
      return "You have tried too many times with wrong email or password. Try again later with right email and password!";
    } else {
      return "";
    }
  }
}
