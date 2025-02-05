import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_crud_project/provider/google_sign_in.dart';
import 'package:flutter_firebase_crud_project/screens/chat_screen/chat_screen.dart';
import 'package:flutter_firebase_crud_project/screens/home_page/home_screen.dart';
import 'package:flutter_firebase_crud_project/screens/search_screen.dart/search_screen.dart';
import 'package:flutter_firebase_crud_project/screens/splash_screen/splash.dart';
import 'package:flutter_firebase_crud_project/screens/user_profile/user_profile.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_crud_project/screens/login_page/login_screen.dart';
import 'package:flutter_firebase_crud_project/screens/signup_page/info_screen.dart';
import 'package:flutter_firebase_crud_project/screens/signup_page/signup_screen.dart';
import 'package:flutter_firebase_crud_project/screens/login_page/forgot_password_screen.dart';
import 'package:flutter_firebase_crud_project/screens/signup_page/terms_conditions_screen.dart';
import 'package:flutter_firebase_crud_project/theme/theme.dart';
import 'package:flutter_firebase_crud_project/l10n/locale_string.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: GetMaterialApp(
          // ! Theme Settings
          theme: CustomTheme.lightTheme,
          darkTheme: CustomTheme.darkTheme,
          themeMode: currentTheme.currentTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: Splash.id,

          routes: {
            Splash.id: (context) => const Splash(),
            LoginScreen.id: (context) => const LoginScreen(),
            ForgotPasswordScreen.id: (context) => const ForgotPasswordScreen(),
            SignupScreen.id: (context) => const SignupScreen(),
            InfoScreen.id: (context) => const InfoScreen(),
            TermsConditionsScreen.id: (context) =>
                const TermsConditionsScreen(),
            HomeScreen.id: (context) => const HomeScreen(),
            ChatScreen.id: (context) => const ChatScreen(
                  userName: "",
                ),
            SearchScreen.id: (context) => const SearchScreen(),
            ProfileScreen.id: (context) => const ProfileScreen(),
          },

          title: 'Login Signup Demo',

          translations: LocaleString(),
          locale: const Locale('en', 'US'),
        ),
      ),
    );
  }
}
