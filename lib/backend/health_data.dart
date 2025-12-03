class HealthData {
  int heartRate;
  int bloodPressure;
  double temperature;
  int oxygenLevel;

  HealthData({
    required this.heartRate,
    required this.bloodPressure,
    required this.temperature,
    required this.oxygenLevel,
  });

  bool isCritical() {
    return (bloodPressure > 160 || heartRate > 120 || temperature > 102.0);
  }

  String getSummary() {
    return "BP: $bloodPressure, HR: $heartRate, Temp: $temperature";
  }
}
