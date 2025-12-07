import 'package:flutter/material.dart';

class ArticleFever extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seasonal Fever"),
        backgroundColor: Colors.orange.shade700,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Image.asset(
              "assets/images/img_4.png"), // replace with seasonal fever image
          SizedBox(height: 20),
          Text(
            "🌿 What is Seasonal Fever?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Seasonal fever is a common illness that occurs during certain times of the year, often due to changes in weather or seasonal infections. "
            "It can be caused by viruses or bacteria and usually spreads more easily when the immune system is weaker.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            "⚠️ Symptoms to Watch For:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "- High temperature or chills\n"
            "- Headache and body aches\n"
            "- Fatigue and weakness\n"
            "- Sore throat or cough\n"
            "- Sneezing or runny nose",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            "🛡️ Prevention Tips:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "- Maintain personal hygiene and wash hands regularly.\n"
            "- Avoid close contact with infected individuals.\n"
            "- Eat nutritious food and stay hydrated to strengthen immunity.\n"
            "- Dress appropriately for weather changes.\n"
            "- Consult a doctor if symptoms persist or worsen.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            "💛 Remember: Seasonal fevers are often preventable with proper care and awareness."
            "Stay safe and healthy!",
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
