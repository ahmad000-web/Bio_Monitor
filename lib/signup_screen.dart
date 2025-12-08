import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import '../user_database.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

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
      appBar: AppBar(title: const Text("Sign Up"), backgroundColor: Colors.teal.shade900),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(26),
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.account_circle),
                labelText: "Full Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: email,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.alternate_email),
                labelText: "Email",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: phone,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.phone),
                labelText: "Phone",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: dob,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.calendar_month),
                labelText: "Date of Birth",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: password,
              obscureText: _isHidden,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(_isHidden ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isHidden = !_isHidden),
                ),
                labelText: "Password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField(
              value: gender,
              items: ["Male", "Female", "Other"]
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) => setState(() => gender = v!),
              decoration: InputDecoration(
                labelText: "Gender",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField(
              value: blood,
              items: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
                  .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                  .toList(),
              onChanged: (v) => setState(() => blood = v!),
              decoration: InputDecoration(
                labelText: "Blood Group",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                if (name.text.isEmpty || email.text.isEmpty || password.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all required fields")),
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
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', true);
                  await prefs.setString('loggedUserEmail', email.text);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Account Created Successfully!")),
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => DashboardPage(userData: userData)),
                  );
                } catch (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Email already exists!")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade900),
              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}
