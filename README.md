# bio_monitor_

The Patient Health Monitoring System is a cross-platform mobile application designed to help users record, track, and analyze their daily health parameters. The app allows users to create an account, log in securely, and enter vital signs such as blood pressure, body temperature, sugar level, heart rate, and symptoms. These readings are processed through a dedicated C++ OOP backend, which analyzes the data and classifies the condition as “Normal,” “Warning,” or “Critical.” In case of a critical condition, the app automatically opens the email interface to notify the doctor with pre filled details without relying on any external API.

To ensure long-term storage and offline accessibility, the application uses an SQLite local database to store user profiles, health checkup history, appointments, diet plans, and yoga/exercise content metadata. Users can book doctor appointments, calculate BMI, view seasonal disease awareness articles, follow yoga exercises through embedded YouTube links, and generate personalized diet plans based on their health profile.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
