import 'package:flutter/material.dart';

class BMI extends StatefulWidget {
  const BMI({Key? key}) : super(key: key);

  @override
  _BMIState createState() => _BMIState();
}

class _BMIState extends State<BMI> {
  final weight = TextEditingController();
  final feet = TextEditingController();
  final inches = TextEditingController();
  final age = TextEditingController();

  Color bgColor = Colors.white;
  String resultMessage = "";

  // BMI Calculation
  double calculateBMI(double weightKg, double heightCm) {
    final heightM = heightCm / 100;
    if (heightM <= 0) return 0;
    return weightKg / (heightM * heightM);
  }

  int getBMICategory(double bmi) {
    if (bmi < 18.5) return 0; // Underweight
    if (bmi < 25) return 1; // Healthy
    if (bmi < 30) return 2; // Overweight
    return 3; // Extreme Overweight
  }

  // MAIN FUNCTION with DIALOG
  void calculateBMIAndUpdateUI() {
    final double w = double.tryParse(weight.text) ?? 0;
    final int f = int.tryParse(feet.text) ?? 0;
    final int i = int.tryParse(inches.text) ?? 0;

    final double heightCm = (f * 12 + i) * 2.54;

    if (w <= 0 || heightCm <= 0) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Input"),
          content: const Text("Please enter valid weight and height."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    final double bmi = calculateBMI(w, heightCm);
    final int category = getBMICategory(bmi);

    String message;
    Color color;

    switch (category) {
      case 0:
        message = "Underweight";
        color = Colors.blue.shade200;
        break;
      case 1:
        message = "Healthy";
        color = Colors.green.shade300;
        break;
      case 2:
        message = "Overweight";
        color = Colors.orange.shade300;
        break;
      case 3:
        message = "Extreme Overweight";
        color = Colors.red.shade300;
        break;
      default:
        message = "";
        color = Colors.white;
    }

    final String feedback = "BMI: ${bmi.toStringAsFixed(1)}\nStatus: $message";

    setState(() {
      resultMessage = feedback;
      bgColor = color;
    });

    // SHOW RESULT DIALOG
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("BMI Result"),
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

  @override
  void dispose() {
    weight.dispose();
    feet.dispose();
    inches.dispose();
    age.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "BMI Calculator",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade900,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: age,
                      decoration: InputDecoration(
                        labelText: "Age",
                        hintText: "Enter your age",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: weight,
                      decoration: InputDecoration(
                        labelText: "Weight (kg)",
                        hintText: "Enter your weight",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: feet,
                      decoration: InputDecoration(
                        labelText: "Feet",
                        hintText: "Height (feet)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: inches,
                      decoration: InputDecoration(
                        labelText: "Inches",
                        hintText: "Height (inches)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateBMIAndUpdateUI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade900,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  "Check BMI",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                resultMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
