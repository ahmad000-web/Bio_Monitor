//Page 6 Signup

import 'package:bio_monitor/dashboard.dart';
import 'package:flutter/material.dart';

import 'user_database.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade900,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: name,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.account_circle_sharp),
                  labelText: "Full Name",
                  hintText: "username",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11)),
                ),
              ),
              SizedBox(height: 20),

              // TextField(
              //   controller: name,
              //   decoration: InputDecoration(
              //       hintText: "user",
              //       labelText: "Full Name",
              //       focusedBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(11))),
              // ),
              //const SizedBox(height: 10),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.alternate_email),
                  labelText: "Email",
                  hintText: "user@gmail.com",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11)),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.phone,
                controller: phone,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.phone),
                  labelText: "phone",
                  hintText: "0300-000000",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11)),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                controller: dob,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.calendar_month_outlined),
                  labelText: "Date of Birth DD/MM/YYYY",
                  hintText: "e.g 01/02/2000",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11)),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: password,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isHidden ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isHidden = !_isHidden;
                      });
                    },
                  ),
                  hintText: "******",
                  labelText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11)),
                ),
                obscureText: _isHidden,
              ),

              SizedBox(height: 20),

              // Gender Dropdown
              DropdownButtonFormField(
                value: gender,
                items: ["Male", "Female", "Other"]
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (value) => setState(() => gender = value!),
                decoration: InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11)),
                ),
              ),
              SizedBox(height: 15),

              // Blood Group Dropdown
              DropdownButtonFormField(
                value: blood,
                items: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
                    .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                    .toList(),
                onChanged: (value) => setState(() => blood = value!),
                decoration: InputDecoration(
                    labelText: "Blood Group",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11))),
              ),

              SizedBox(height: 30),

              ElevatedButton(
                child: Text("Create Account"),
                onPressed: () async {
                  if (name.text.isEmpty ||
                      email.text.isEmpty ||
                      password.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Please fill all required fields")),
                    );
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

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Account Created Successfully!")),
                    );

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DashboardPage(userData: userData)));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Email already exists!")),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
