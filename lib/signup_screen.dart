// File: lib/pages/signup_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/google_sign_in_service.dart';
import 'dashboard.dart';
import '../user_database.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final dob = TextEditingController();
  final password = TextEditingController();

  String gender = "Male";
  String blood = "A+";
  bool _isHidden = true;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    dob.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> signupWithGoogle() async {
    final account = await signInWithGoogle();
    if (account != null) {
      final tokens = await getGoogleTokens(account);
      if (tokens != null) {
        final emailStr = tokens['email'] ?? "";
        final displayName = tokens['displayName'] ?? "Unknown";

        final userData = {
          "name": displayName,
          "email": emailStr,
          "phone": "",
          "dob": "",
          "password": "",
          "gender": "Other",
          "blood": "N/A",
        };
        try {
          await UserDatabase.instance.insertUser(userData);
        } catch (e) {}
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('loggedUserEmail', emailStr);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DashboardPage(userData: userData)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up"), backgroundColor: Colors.teal.shade900),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(26),
        child: Column(
          children: [
            TextField(controller: name, decoration: InputDecoration(labelText: "Full Name", border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)), suffixIcon: Icon(Icons.account_circle_sharp))),
            SizedBox(height: 20),
            TextField(controller: email, decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)), suffixIcon: Icon(Icons.alternate_email))),
            SizedBox(height: 20),
            TextField(controller: phone, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: "Phone", border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)), suffixIcon: Icon(Icons.phone))),
            SizedBox(height: 20),
            TextField(controller: dob, decoration: InputDecoration(labelText: "Date of Birth", border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)), suffixIcon: Icon(Icons.calendar_month_outlined))),
            SizedBox(height: 20),
            TextField(
              controller: password,
              obscureText: _isHidden,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                suffixIcon: IconButton(
                  icon: Icon(_isHidden ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isHidden = !_isHidden),
                ),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField(
              value: gender,
              items: ["Male", "Female", "Other"].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (v) => setState(() => gender = v!),
              decoration: InputDecoration(labelText: "Gender", border: OutlineInputBorder(borderRadius: BorderRadius.circular(11))),
            ),
            SizedBox(height: 15),
            DropdownButtonFormField(
              value: blood,
              items: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"].map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
              onChanged: (v) => setState(() => blood = v!),
              decoration: InputDecoration(labelText: "Blood Group", border: OutlineInputBorder(borderRadius: BorderRadius.circular(11))),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text("Create Account"),
              onPressed: () async {
                if (name.text.isEmpty || email.text.isEmpty || password.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all required fields")));
                  return;
                }
                final userData = {
                  "name": name.text,
                  "email": email.text,
                  "phone": phone.text,
                  "dob": dob.text,
                  "password": password.text,
                  "gender": gender,
                  "blood": blood,
                };
                try {
                  await UserDatabase.instance.insertUser(userData);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', true);
                  await prefs.setString('loggedUserEmail', email.text);

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardPage(userData: userData)));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email already exists!")));
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Image.asset("assets/images/google_logo.png", height: 24, width: 24),
              label: Text("Sign up with Google"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: signupWithGoogle,
            ),
          ],
        ),
      ),
    );
  }
}
