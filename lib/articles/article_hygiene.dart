import 'package:flutter/material.dart';

class ArticleHygiene extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hygiene Awareness"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Image.asset("assets/images/img_5.png"), // replace with hygiene image
          SizedBox(height: 20),
          Text(
            "🌿 What is Personal Hygiene?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Hygiene refers to practices that help maintain health and prevent the spread of diseases. "
            "Good personal hygiene is essential for overall well-being and reduces the risk of infections and illnesses.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            "⚠️ Key Hygiene Practices:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "- Wash hands regularly with soap and water.\n"
            "- Brush and floss teeth twice a day.\n"
            "- Bathe regularly and maintain clean clothing.\n"
            "- Keep nails trimmed and clean.\n"
            "- Cover mouth and nose while sneezing or coughing.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            "🛡️ Benefits of Good Hygiene:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "- Reduces risk of infections and diseases.\n"
            "- Promotes good mental and physical health.\n"
            "- Prevents unpleasant body odor.\n"
            "- Improves social interactions and confidence.\n"
            "- Supports overall well-being.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            "💛 Remember: Practicing good hygiene is simple but powerful. Stay clean, stay healthy!",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
