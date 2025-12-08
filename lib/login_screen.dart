import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/google_sign_in_service.dart';
import 'dashboard.dart';
import '../user_database.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool _isHidden = true;

  // Login with email/password
  Future<void> loginUser() async {
    setState(() => isLoading = true);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password.")),
      );
      return;
    }

    final user = await UserDatabase.instance.login(email, password);
    setState(() => isLoading = false);

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('loggedUserEmail', user['email'] ?? "");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardPage(userData: user)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

  // Login with Google
  Future<void> loginWithGoogle() async {
    final account = await signInWithGoogle();
    if (account != null) {
      final tokens = await getGoogleTokens(account);
      if (tokens != null) {
        final email = tokens['email'] ?? "";
        final displayName = tokens['displayName'] ?? "Unknown";

        // Save session
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('loggedUserEmail', email);

        // Save user to database if not exists
        final userData = {
          'name': displayName,
          'email': email,
          'phone': "",
          'dob': "",
          'password': "",
          'gender': 'Other',
          'blood': 'N/A',
        };
        try {
          await UserDatabase.instance.insertUser(userData);
        } catch (e) {
          // Ignore if already exists
        }

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
      appBar: AppBar(title: const Text("Login"), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(26),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset("assets/images/img_9.png", width: 200, height: 170),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "user@gmail.com",
                    suffixIcon: const Icon(Icons.alternate_email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: _isHidden,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "******",
                    suffixIcon: IconButton(
                      icon: Icon(_isHidden ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _isHidden = !_isHidden),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: loginUser,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text("Login", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Image.asset("assets/images/google_logo.png", height: 24, width: 24),
                  label: const Text("Sign in with Google"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: loginWithGoogle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
