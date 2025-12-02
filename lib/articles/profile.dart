import 'dart:io';

import 'package:bio_monitor/editprofilepage.dart'; // Separate file for EditProfilePage
import 'package:bio_monitor/user_database.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  ProfilePage({required this.userData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    userData = widget.userData;
  }

  // Refresh data from DB
  Future<void> refreshUser() async {
    final updatedUser =
        await UserDatabase.instance.getUserByEmail(userData['email']);
    if (updatedUser != null) {
      setState(() {
        userData = updatedUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.teal.shade900,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final updatedUser = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfilePage(userData: userData),
                ),
              );

              if (updatedUser != null) {
                setState(() {
                  userData = updatedUser;
                });
              }
            },
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: userData['photoPath'] != null
                  ? FileImage(File(userData['photoPath']))
                  : AssetImage("assets/images/img_7.png") as ImageProvider,
            ),
          ),
          SizedBox(height: 20),
          info("Name", userData['name']),
          info("Email", userData['email']),
          info("Phone", userData['phone']),
          info("Gender", userData['gender']),
          info("Blood Group", userData['blood']),
          info("DOB", userData['dob']),
        ],
      ),
    );
  }

  Widget info(String label, String value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
