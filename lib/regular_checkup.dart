import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database_helper.dart';
import '../services/google_sign_in_service.dart';
import '../services/gmail_api_service.dart';

// Ideal ranges
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

String evaluateHealth({
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
    report += "\n⚠️ Your health is NOT ideal. Please monitor yourself or consult a doctor.";
  } else {
    report += "\n✅ You are in safe and stable condition.";
  }

  return report;
}

class RegularCheckupScreen extends StatefulWidget {
  const RegularCheckupScreen({super.key});

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
        title: const Text("Regular Checkup"),
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
              child: const Text("Submit"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade900,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController c, String label) => TextField(
    controller: c,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
  );

  Future<void> _submitCheckup() async {
    double systolic = double.tryParse(systolicController.text) ?? 0;
    double diastolic = double.tryParse(diastolicController.text) ?? 0;
    double pulse = double.tryParse(pulseController.text) ?? 0;
    double temp = double.tryParse(tempController.text) ?? 0;
    double sugar = double.tryParse(sugarController.text) ?? 0;

    String feedback = evaluateHealth(
      systolic: systolic,
      diastolic: diastolic,
      pulse: pulse,
      temp: temp,
      sugar: sugar,
      fever: hasFever,
      cough: hasCough,
      headache: hasHeadache,
    );

    bool unsafe = feedback.contains("⚠️");

    // Send email if unsafe
    // Check if health is unsafe
    if (unsafe) {
      // Force user to sign in with Google to get fresh token
      final account = await signInWithGoogle();
      if (account != null) {
        final auth = await account.authentication; // fresh token
        final accessToken = auth.accessToken;
        final email = account.email;

        if (accessToken != null) {
          await sendMishapEmailWithGmailAPI(
            accessToken,
            email,
            "doctor@example.com", // replace with doctor email
            feedback,
          );
          print("Email sent successfully to doctor.");
        } else {
          print("Failed to get Google access token.");
        }
      } else {
        print("User did not sign in with Google.");
      }
    }


    // Save checkup to database
    await DatabaseHelper().insertCheckup({
      "date": DateTime.now().toString().split(" ")[0],
      "time": TimeOfDay.now().format(context),
      "result": feedback,
    });

    // Show feedback
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Checkup Result"),
        content: Text(feedback),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("OK")),
        ],
      ),
    );
  }
}
