

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trp_shut_off/screens/login_screen.dart';
import 'package:trp_shut_off/screens/user_profile.dart';
import 'data/token_storage.dart';
import 'globals.dart' as globals;

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  start() async {
    HttpOverrides.global = new MyHttpOverrides();
    WidgetsFlutterBinding.ensureInitialized();
    // globals.token = await getTokenFromStorage();
    await Future.delayed(Duration(seconds: 3));
    String _token = await getTokenFromStorage();
    if (_token != null) {
      rootToStartScreen();
    } else {
      rootToLoginScreen();
    }
  }

  @override
  void initState() {
    super.initState();
    start();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black12,
      body: new Center(
        child: new Image.asset('images/splash.png'),
      ),
    );
  }

  rootToStartScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => UserProfileScreen()),
          (Route<dynamic> route) => false,
    );
  }

  rootToLoginScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LogInScreen()),
          (Route<dynamic> route) => false,
    );
  }
}



class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}