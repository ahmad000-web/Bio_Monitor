// Page 3 login/getstarted

import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomePage extends StatelessWidget {
  final String title;

  const WelcomePage({super.key, this.title = "Welcome"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome",
          style: TextStyle(color: Colors.teal.shade900),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/img_1.png",
              width: 250,
              height: 200,
            ),

            //const SizedBox(height: 20),

            // Text(
            //   "Know Your Numbers. Own Your Health.",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //   ),
            //   textAlign: TextAlign.center,
            // ),

            const SizedBox(height: 10),

            // LOGIN BUTTON
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade900),
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            // SIGNUP BUTTON
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SignupScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade900),
              child: Text(
                "Create Account",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
