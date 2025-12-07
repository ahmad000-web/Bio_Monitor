import 'package:flutter/material.dart';

class ArticleHepatitis extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hepatitis Awareness"),
        backgroundColor: Colors.green.shade700,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Image.asset(
              "assets/images/img_6.png"), // replace with hepatitis image
          SizedBox(height: 20),
          Text(
            "🌿 What is Hepatitis?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Hepatitis is an inflammation of the liver, usually caused by a viral infection. "
            "There are several types of hepatitis viruses (A, B, C, D, and E), each with different modes of transmission and severity.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            "⚠️ Symptoms to Watch For:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "- Fatigue and weakness\n"
            "- Nausea, vomiting, or loss of appetite\n"
            "- Abdominal pain, especially near the liver\n"
            "- Jaundice (yellowing of skin and eyes)\n"
            "- Dark urine and pale stools",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            "🛡️ Prevention Tips:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "- Get vaccinated for hepatitis A and B.\n"
            "- Avoid sharing needles, razors, or personal hygiene items.\n"
            "- Practice safe sex and use protection.\n"
            "- Maintain proper sanitation and wash hands regularly.\n"
            "- Seek medical attention if symptoms appear.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            "💛 Remember: Awareness and vaccination are key to preventing hepatitis. Protect your liver, protect your life!",
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
