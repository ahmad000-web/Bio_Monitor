import 'package:bio_monitor/backend/user.dart';

class Doctor extends User {
  String specialization;

  Doctor({
    required String name,
    required String email,
    required this.specialization,
  }) : super(userID: "D01", name: name, email: email);

  void reviewReport() {
    print("Doctor reviewing report...");
  }
}
