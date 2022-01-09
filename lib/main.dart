import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:website_application/splash.dart';


void main() async {
  await init();
  runApp(MyApp());
}

Future init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Webview',
      home: const SafeArea(child: Splash()),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ignore: must_be_immutable
