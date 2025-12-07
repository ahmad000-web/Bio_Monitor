import 'package:bio_monitor/db/database_helper.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> checkups = [];
  List<Map<String, dynamic>> appointments = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final db = DatabaseHelper();
    final chk = await db.getCheckups();
    final app = await db.getAppointments();

    setState(() {
      checkups = chk;
      appointments = app;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: Colors.teal.shade900,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Checkup History",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...checkups.map((item) => Card(
                elevation: 3,
                child: ListTile(
                  title: Text("${item['date']} — ${item['time']}"),
                  subtitle: Text(item['result']),
                ),
              )),
          const SizedBox(height: 20),
          const Text("Appointment History",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...appointments.map((item) => Card(
                elevation: 3,
                child: ListTile(
                  title: Text("${item['doctor']} (${item['specialization']})"),
                  subtitle:
                      Text("Date: ${item['date']} | Time: ${item['time']}"),
                ),
              )),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
