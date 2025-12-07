import 'package:flutter/material.dart';

class ArticleDengue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dengue Awareness"),
        backgroundColor: Colors.red.shade700,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Image.asset("assets/images/img_3.png"),
          SizedBox(height: 20),
          Text(
            "🌿 What is Dengue Virus?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Dengue is a mosquito-borne viral infection caused by the Dengue virus. "
            "It spreads primarily through the bite of the Aedes aegypti mosquito, "
            "which is most active during early morning and evening hours.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            "⚠️ Symptoms to Watch For:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "- High fever\n"
            "- Severe headache\n"
            "- Pain behind the eyes\n"
            "- Muscle and joint pain\n"
            "- Nausea, vomiting, and rash",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            "🛡️ Prevention Tips:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "- Eliminate standing water around homes to stop mosquito breeding.\n"
            "- Use mosquito repellents and wear long-sleeved clothing.\n"
            "- Keep doors and windows closed or use screens.\n"
            "- Seek medical attention if symptoms appear.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            "💛 Remember: Early detection and preventive measures can save lives. "
            "Let's fight dengue together!",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
