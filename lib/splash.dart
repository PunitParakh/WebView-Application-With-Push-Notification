import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:website_application/webview.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    navigatetoHome();
  }

  navigatetoHome() async {
    await Future.delayed(const Duration(milliseconds: 3000), () {});
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Webpage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255,126,48,0),
      body: Center(
        child: Image.asset("assets/playstore.png",
        fit: BoxFit.cover,
        height: double.maxFinite,
        //width: double.infinity,
        alignment: Alignment.center,),
      ),
    );
  }
} 


// "assets/splash.jpeg"