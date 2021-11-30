import 'package:flutter_firebase_crud_project/screens/login_page/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String id = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController newFirstNameController = TextEditingController();
  final TextEditingController newLastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // String? url = "";
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
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          "Upadate",
          style: TextStyle(fontSize: 18),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Color(0xFF1cbb7c),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
              // authController.logout(context);
            },
            icon: const Icon(Icons.logout),
            color: const Color(0xFF1cbb7c),
          ),
        ],
      ),
      body: Column(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 34),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.43,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double innerHeight = constraints.maxHeight;
                            double innerWidth = constraints.maxWidth;
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: innerHeight * 0.72,
                                    width: innerWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 80,
                                        ),
                                        const Text(
                                          "Kamrul Islam",
                                          style: TextStyle(
                                            color: Color(0xFF1cbb7c),
                                            fontSize: 37,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "kamrul@gmail.com",
                                          style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: const Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              "Delete Account",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 110,
                                  right: 20,
                                  child: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (context) => Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
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
                                    color: Colors.grey[700],
                                  ),
                                ),
                                // Positioned(
                                //   top: 0,
                                //   left: 0,
                                //   right: 0,
                                //   child: Center(
                                //     child: ClipRRect(
                                //       borderRadius:
                                //           BorderRadius.circular(200),
                                //       child: CachedNetworkImage(
                                //         width: 150,
                                //         height: 150,
                                //         fit: BoxFit.fitWidth,
                                //         imageUrl: url,
                                //         placeholder: (context, url) =>
                                //             const CircularProgressIndicator(
                                //           strokeWidth: 4.0,
                                //         ),
                                //         errorWidget: (context, url, error) =>
                                //             const Icon(Icons.error),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
