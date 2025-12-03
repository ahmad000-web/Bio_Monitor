import 'health_data.dart';
import 'user.dart';

class Patient extends User {
  int age;
  List<HealthData> medicalHistory = [];

  Patient({
    required String id,
    required String name,
    required String email,
    required this.age,
  }) : super(userID: id, name: name, email: email);

  void updateHealthData(HealthData data) {
    medicalHistory.add(data);
  }
}
