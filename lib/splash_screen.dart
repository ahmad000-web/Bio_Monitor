//Page 1

import 'dart:async';
import 'package:bio_monitor/getstarted.dart';
import 'package:flutter/material.dart';
import 'package:bio_monitor/dashboard.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage(  userData: {
          "name": "Test User",
          "email": "test@example.com",
          "photoPath": null,
        }, )),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Image.asset(
          "assets/images/img_2.png",
        ),
      ),
    );
  }
}
