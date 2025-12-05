import 'package:flutter/material.dart';

import 'db/database_helper.dart';

class AppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const AppointmentScreen({super.key, required this.userData});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  // Patient controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Doctor selection
  String? selectedDoctor;

  // Doctor data: name -> {email, specialization}
  final Map<String, Map<String, String>> doctors = {
    "Dr. Ali (Cardiologist)": {
      "email": "dr.ali@example.com",
      "specialization": "Cardiologist"
    },
    "Dr. Sara (General Physician)": {
      "email": "dr.sara@example.com",
      "specialization": "General Physician"
    },
    "Dr. Ahmed (Endocrinologist)": {
      "email": "dr.ahmed@example.com",
      "specialization": "Endocrinologist"
    },
    "Dr. Noor Pulmonologist": {
      "email": "dr.noor@example.com",
      "specialization": "Pulmonologist"
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Book Appointment"),
        backgroundColor: Colors.teal.shade900,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Patient Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              _buildTextField(nameController, "Full Name"),
              const SizedBox(height: 15),
              _buildTextField(contactController, "Contact Number",
                  keyboard: TextInputType.phone),
              const SizedBox(height: 15),
              _buildTextField(notesController, "Reason / Notes", maxLines: 2),
              const SizedBox(height: 20),

              const Text(
                "Select Doctor",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                value: selectedDoctor,
                items: doctors.entries.map((entry) {
                  String name = entry.key;
                  String specialization = entry.value['specialization']!;
                  return DropdownMenuItem<String>(
                    value: name,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(specialization,
                            style: const TextStyle(
                                fontSize: 0.1, color: Colors.grey)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDoctor = value;
                  });
                },
              ),
              const SizedBox(height: 30),

              // Date Picker
              Row(
                children: [
                  Expanded(
                    child: Text(selectedDate != null
                        ? "Selected Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                        : "No Date Selected"),
                  ),
                  ElevatedButton(
                    onPressed: _pickDate,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade900),
                    child: const Text("Select Date"),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Time Picker
              Row(
                children: [
                  Expanded(
                    child: Text(selectedTime != null
                        ? "Selected Time: ${selectedTime!.format(context)}"
                        : "No Time Selected"),
                  ),
                  ElevatedButton(
                    onPressed: _pickTime,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade900),
                    child: const Text("Select Time"),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _submitAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade900,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: const Text("Book Appointment",
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  Future<void> _submitAppointment() async {
    if (nameController.text.isEmpty ||
        contactController.text.isEmpty ||
        selectedDoctor == null ||
        selectedDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    String doctorName = selectedDoctor!;
    String specialization = doctors[doctorName]!['specialization']!;

    // Save to db
    await DatabaseHelper().insertAppointment({
      "doctor": doctorName,
      "specialization": specialization,
      "date":
          "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
      "time": selectedTime!.format(context),
      "notes": notesController.text,
    });

    // Confirmation dialog
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Appointment Booked"),
        content: Text(
          "Patient: ${nameController.text}\n"
          "Doctor: $doctorName\n"
          "Specialization: $specialization\n"
          "Contact: ${contactController.text}\n"
          "Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}\n"
          "Time: ${selectedTime!.format(context)}\n"
          "Notes: ${notesController.text}",
        ),
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
