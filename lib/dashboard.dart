import 'dart:io';
import 'package:bio_monitor/services/google_sign_in_service.dart';
import 'package:bio_monitor/articles/article_dengue.dart';
import 'package:bio_monitor/articles/article_fever.dart';
import 'package:bio_monitor/articles/article_hepatitis.dart';
import 'package:bio_monitor/articles/article_hygiene.dart';
import 'package:bio_monitor/articles/profile.dart';
import 'package:bio_monitor/bmi.dart';
import 'package:bio_monitor/getstarted.dart';
import 'package:bio_monitor/yogaexercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'appointment.dart';
import 'history_checkup.dart';
import 'regular_checkup.dart';
import 'user_database.dart';
// Ideal ranges for a healthy adult

class DashboardPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  DashboardPage({required this.userData});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Map<String, dynamic> userData;

  final List<Map<String, dynamic>> diseaseArticles = [
    {
      "title": "Dengue",
      "image": "assets/images/img_3.png",
      "page": ArticleDengue(),
    },
    {
      "title": "Seasonal Fever",
      "image": "assets/images/img_4.png",
      "page": ArticleFever(),
    },
    {
      "title": "Hygiene",
      "image": "assets/images/img_5.png",
      "page": ArticleHygiene(),
    },
    {
      "title": "Hepatitis",
      "image": "assets/images/img_6.png",
      "page": ArticleHepatitis(),
    },
  ];

  @override
  void initState() {
    super.initState();
    userData = widget.userData;
  }

  // Refresh userData after returning from ProfilePage
  Future<void> refreshUser(Map<String, dynamic>? updatedUser) async {
    if (updatedUser != null) {
      setState(() {
        userData = updatedUser;
      });
    } else {
      // Fetch latest data from db
      final latestUser =
          await UserDatabase.instance.getUserByEmail(userData['email']);
      if (latestUser != null) {
        setState(() {
          userData = latestUser;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.teal.shade900,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: userData['photoPath'] != null
                    ? FileImage(File(userData['photoPath']))
                    : AssetImage("assets/images/img_7.png") as ImageProvider,
              ),
              SizedBox(width: 10),
              Text(
                userData['name'],
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.teal.shade900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: userData['photoPath'] != null
                          ? FileImage(File(userData['photoPath']))
                          : AssetImage("assets/images/img_7.png")
                              as ImageProvider,
                    ),
                    SizedBox(height: 10),
                    Text(
                      userData['name'],
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Profile"),
                onTap: () async {
                  final updatedUser = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfilePage(userData: userData),
                    ),
                  );
                  await refreshUser(updatedUser);
                  Navigator.pop(context); // Close drawer
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => GetStarted()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [// --- GOOGLE SIGN-IN BUTTON ---
            ElevatedButton.icon(
              icon: Icon(Icons.login),
              label: Text("Sign in with Google"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () async {
                final account = await signInWithGoogle();
                if (account != null) {
                  final tokens = await getGoogleTokens(account);
                  if (tokens != null) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('googleEmail', tokens['email'] ?? '');
                    await prefs.setString('accessToken', tokens['accessToken'] ?? '');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Signed in as ${tokens['email']}")),
                    );
                  }
                }
              },
            ),

            SizedBox(height: 20),

            Text(
              "Disease Awareness",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: diseaseArticles.length,
                itemBuilder: (context, index) {
                  var item = diseaseArticles[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => item["page"]),
                      );
                    },
                    child: Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(item["image"]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                        child: Text(
                          item["title"],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 25),
            Text(
              "Actions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            actionTile("Regular Check", page: const RegularCheckupScreen()),
            actionTile("Book Appointment",
                page: AppointmentScreen(
                    userData: userData)), // leave empty for now
            actionTile("Check BMI", page: const BMI()),
            actionTile("History of Checkup",
                page: const HistoryPage()), // leave empty for now
            actionTile("Yoga", page: YogaExercisePage()),
          ],
        ),
      ),
    );
  }

  Widget actionTile(String title, {Widget? page}) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => page),
            );
          }
        },
      ),
    );
  }
}
