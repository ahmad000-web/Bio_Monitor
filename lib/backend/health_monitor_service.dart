import 'health_data.dart';
import 'patient.dart';

class HealthMonitorService {
  Patient patient;

  HealthMonitorService(this.patient);

  bool checkCritical(HealthData data) {
    return data.isCritical();
  }

  void alertDoctor() {
    print("Sending alert to doctor for patient ${patient.name}");
  }
}
