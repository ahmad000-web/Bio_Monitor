import 'package:flutter/material.dart';

import '../services/gmail_api_service.dart';
import '../user_database.dart';

const double IDEAL_SYSTOLIC_MIN = 90;
const double IDEAL_SYSTOLIC_MAX = 120;
const double IDEAL_DIASTOLIC_MIN = 60;
const double IDEAL_DIASTOLIC_MAX = 80;
const double IDEAL_TEMP_MIN = 36.1;
const double IDEAL_TEMP_MAX = 37.2;
const double IDEAL_PULSE_MIN = 60;
const double IDEAL_PULSE_MAX = 100;
const double IDEAL_SUGAR_MIN = 70;
const double IDEAL_SUGAR_MAX = 140;
const double TOLERANCE = 5;

// -----------------------------
//   HEALTH EVALUATION FUNCTION
// -----------------------------
String evaluateHealth({
  required String userName,
  required double systolic,
  required double diastolic,
  required double pulse,
  required double temp,
  required double sugar,
  required bool fever,
  required bool cough,
  required bool headache,
}) {
  bool unsafe = false;
  String report = "";

  if (systolic < IDEAL_SYSTOLIC_MIN - TOLERANCE ||
      diastolic < IDEAL_DIASTOLIC_MIN - TOLERANCE) {
    report += "• Blood Pressure is LOW.\n";
    unsafe = true;
  } else if (systolic > IDEAL_SYSTOLIC_MAX + TOLERANCE ||
      diastolic > IDEAL_DIASTOLIC_MAX + TOLERANCE) {
    report += "• Blood Pressure is HIGH.\n";
    unsafe = true;
  } else {
    report += "• Blood Pressure is NORMAL.\n";
  }

  if (pulse < IDEAL_PULSE_MIN - TOLERANCE) {
    report += "• Pulse is LOW.\n";
    unsafe = true;
  } else if (pulse > IDEAL_PULSE_MAX + TOLERANCE) {
    report += "• Pulse is HIGH.\n";
    unsafe = true;
  } else {
    report += "• Pulse is NORMAL.\n";
  }

  if (temp < IDEAL_TEMP_MIN - 0.3) {
    report += "• Temperature is LOW.\n";
    unsafe = true;
  } else if (temp > IDEAL_TEMP_MAX + 0.3) {
    report += "• Temperature is HIGH.\n";
    unsafe = true;
  } else {
    report += "• Temperature is NORMAL.\n";
  }

  if (sugar < IDEAL_SUGAR_MIN - 10) {
    report += "• Sugar is LOW.\n";
    unsafe = true;
  } else if (sugar > IDEAL_SUGAR_MAX + 10) {
    report += "• Sugar is HIGH.\n";
    unsafe = true;
  } else {
    report += "• Sugar is NORMAL.\n";
  }

  if (fever || cough || headache) {
    report += "• Symptoms detected.\n";
    unsafe = true;
  }

  if (unsafe) {
    report =
        "$report\n⚠️ $userName's health is NOT ideal.Please take actions to normalize it.\n";
  } else {
    report =
        "$report\n✅ $userName is in safe and stable condition.All parameters are normal.";
  }

  return report;
}

class RegularCheckupScreen extends StatefulWidget {
  final String userEmail;

  const RegularCheckupScreen({super.key, required this.userEmail});

  @override
  State<RegularCheckupScreen> createState() => _RegularCheckupScreenState();
}

class _RegularCheckupScreenState extends State<RegularCheckupScreen> {
  final systolicController = TextEditingController();
  final diastolicController = TextEditingController();
  final pulseController = TextEditingController();
  final tempController = TextEditingController();
  final sugarController = TextEditingController();

  bool hasFever = false;
  bool hasCough = false;
  bool hasHeadache = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Regular Checkup",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade900,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(systolicController, "Systolic BP (mmHg)"),
            const SizedBox(height: 10),
            _buildTextField(diastolicController, "Diastolic BP (mmHg)"),
            const SizedBox(height: 10),
            _buildTextField(pulseController, "Pulse Rate (bpm)"),
            const SizedBox(height: 10),
            _buildTextField(tempController, "Temperature (°C)"),
            const SizedBox(height: 10),
            _buildTextField(sugarController, "Sugar Level (mg/dL)"),
            const SizedBox(height: 15),
            CheckboxListTile(
              title: const Text("Fever?"),
              value: hasFever,
              onChanged: (v) => setState(() => hasFever = v ?? false),
            ),
            CheckboxListTile(
              title: const Text("Cough?"),
              value: hasCough,
              onChanged: (v) => setState(() => hasCough = v ?? false),
            ),
            CheckboxListTile(
              title: const Text("Headache?"),
              value: hasHeadache,
              onChanged: (v) => setState(() => hasHeadache = v ?? false),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitCheckup,
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade900,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController c, String label) => TextField(
        controller: c,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      );
  Future<void> _submitCheckup() async {
    double systolic = double.tryParse(systolicController.text) ?? 0;
    double diastolic = double.tryParse(diastolicController.text) ?? 0;
    double pulse = double.tryParse(pulseController.text) ?? 0;
    double temp = double.tryParse(tempController.text) ?? 0;
    double sugar = double.tryParse(sugarController.text) ?? 0;

    //  Fetch user info
    final user = await UserDatabase.instance.getUserByEmail(widget.userEmail);
    final userName = user?['name'] ?? "User";

    // Evaluate health with userName
    String feedback = evaluateHealth(
      userName: userName,
      systolic: systolic,
      diastolic: diastolic,
      pulse: pulse,
      temp: temp,
      sugar: sugar,
      fever: hasFever,
      cough: hasCough,
      headache: hasHeadache,
    );

    bool unsafe = feedback.contains("NOT ideal");

    // Send alert email if unsafe
    if (unsafe) {
      await sendAlertEmail(feedback, widget.userEmail);
    }

    // Show feedback dialog
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Checkup Result"),
        content: Text(feedback),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
