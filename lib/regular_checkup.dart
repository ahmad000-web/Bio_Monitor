import 'package:flutter/material.dart';

import 'db/database_helper.dart';

// Ideal ranges
const double IDEAL_SYSTOLIC_MIN = 90;
const double IDEAL_SYSTOLIC_MAX = 120;
const double IDEAL_DIASTOLIC_MIN = 60;
const double IDEAL_DIASTOLIC_MAX = 80;
const double IDEAL_TEMP_MIN = 36.1; // °C
const double IDEAL_TEMP_MAX = 37.2;
const double IDEAL_PULSE_MIN = 60;
const double IDEAL_PULSE_MAX = 100;
const double IDEAL_SUGAR_MIN = 70;
const double IDEAL_SUGAR_MAX = 140; // mg/dL
const double TOLERANCE = 5; // +/- tolerance
// Evaluation function
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
  // Blood Pressure
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
  // Pulse
  if (pulse < IDEAL_PULSE_MIN - TOLERANCE) {
    report += "• Pulse is LOW.\n";
    unsafe = true;
  } else if (pulse > IDEAL_PULSE_MAX + TOLERANCE) {
    report += "• Pulse is HIGH.\n";
    unsafe = true;
  } else {
    report += "• Pulse is NORMAL.\n";
  }
  // Temperature
  if (temp < IDEAL_TEMP_MIN - 0.3) {
    report += "• Temperature is LOW.\n";
    unsafe = true;
  } else if (temp > IDEAL_TEMP_MAX + 0.3) {
    report += "• Temperature is HIGH.\n";
    unsafe = true;
  } else {
    report += "• Temperature is NORMAL.\n";
  }
  // Sugar
  if (sugar < IDEAL_SUGAR_MIN - 10) {
    report += "• Sugar is LOW.\n";
    unsafe = true;
  } else if (sugar > IDEAL_SUGAR_MAX + 10) {
    report += "• Sugar is HIGH.\n";
    unsafe = true;
  } else {
    report += "• Sugar is NORMAL.\n";
  }
  // Symptoms
  if (fever || cough || headache) {
    report += "• Symptoms detected.\n";
    unsafe = true;
  }
  // Final feedback
  if (unsafe) {
    report +=
        "\n⚠️ Your health is NOT ideal. Please monitor yourself or consult a doctor.";
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
  final TextEditingController systolicController = TextEditingController();
  final TextEditingController diastolicController = TextEditingController();
  final TextEditingController pulseController = TextEditingController();
  final TextEditingController tempController = TextEditingController();
  final TextEditingController sugarController = TextEditingController();

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter your health parameters:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTextField(systolicController, "Systolic BP (mmHg)"),
            const SizedBox(height: 10),
            _buildTextField(diastolicController, "Diastolic BP (mmHg)"),
            const SizedBox(height: 15),
            _buildTextField(pulseController, "Pulse Rate (bpm)"),
            const SizedBox(height: 15),
            _buildTextField(tempController, "Temperature (°C)"),
            const SizedBox(height: 15),
            _buildTextField(sugarController, "Sugar Level (mg/dL)"),
            const SizedBox(height: 15),
            CheckboxListTile(
              title: const Text("Do you have Fever?"),
              value: hasFever,
              onChanged: (v) => setState(() => hasFever = v ?? false),
            ),
            CheckboxListTile(
              title: const Text("Do you have Cough?"),
              value: hasCough,
              onChanged: (v) => setState(() => hasCough = v ?? false),
            ),
            CheckboxListTile(
              title: const Text("Do you have Headache?"),
              value: hasHeadache,
              onChanged: (v) => setState(() => hasHeadache = v ?? false),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitCheckup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade900,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text("Submit",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

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

    // Save to db
    await DatabaseHelper().insertCheckup({
      "date": DateTime.now().toString().split(" ")[0],
      "time": TimeOfDay.now().format(context),
      "result": feedback,
    });

    // Show feedback dialog
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          "Checkup Result",
        ),
        content: Text(feedback),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // CLOSE ONLY THE DIALOG
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
