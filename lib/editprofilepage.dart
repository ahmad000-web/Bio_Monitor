import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'user_database.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  EditProfilePage({required this.userData});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController dobController;
  late TextEditingController genderController;
  late TextEditingController bloodController;

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userData['name']);
    emailController = TextEditingController(text: widget.userData['email']);
    phoneController = TextEditingController(text: widget.userData['phone']);
    dobController = TextEditingController(text: widget.userData['dob']);
    genderController = TextEditingController(text: widget.userData['gender']);
    bloodController = TextEditingController(text: widget.userData['blood']);

    if (widget.userData['photoPath'] != null) {
      _imageFile = File(widget.userData['photoPath']);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    genderController.dispose();
    bloodController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    // Optional: Check email uniqueness
    final existingUser =
        await UserDatabase.instance.getUserByEmail(emailController.text);
    if (existingUser != null && existingUser['id'] != widget.userData['id']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email already in use by another account")),
      );
      return;
    }

    final updatedData = {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'dob': dobController.text,
      'gender': genderController.text,
      'blood': bloodController.text,
      'photoPath': _imageFile?.path,
    };

    await UserDatabase.instance.updateUser(widget.userData['id'], updatedData);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Profile updated successfully!")));

    Navigator.pop(context, updatedData); // return updated data to ProfilePage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade900,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : AssetImage("assets/images/img_7.png")
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: _pickImage,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
                validator: (val) =>
                    val!.isEmpty ? "Name cannot be empty" : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (val) =>
                    val!.isEmpty ? "Email cannot be empty" : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "Phone"),
              ),
              TextFormField(
                controller: dobController,
                decoration: InputDecoration(labelText: "Date of Birth"),
              ),
              TextFormField(
                controller: genderController,
                decoration: InputDecoration(labelText: "Gender"),
              ),
              TextFormField(
                controller: bloodController,
                decoration: InputDecoration(labelText: "Blood Group"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade900,
                ),
                onPressed: _saveChanges,
                child: Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
