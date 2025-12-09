// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
//
// Future<void> sendAlertEmail(String report) async {
//   String username = 'biomonitor7829@gmail.com'; // your personal Gmail
//   String appPassword = 'xwqllznzyimucegm'; // 16-char app password
//
//   final smtpServer = gmail(username, appPassword);
//
//   final message = Message()
//     ..from = Address(username, 'BioMonitor App')
//     ..recipients.add('eahmadbhatti@gmail.com') // doctor email
//     ..subject = '⚠️ Health Alert Detected'
//     ..text =""
//         //report;
//     """
// ⚠️ HEALTH ALERT
//
// Patient Name: $name
// Phone Number: $phone
//
// ------------------------------------
// HEALTH REPORT:
// ------------------------------------
// $report
// """;
//
//   try {
//     await send(message, smtpServer);
//     print('Email sent successfully!');
//   } catch (e) {
//     print('Error sending email: $e');
//   }
// }
import 'package:bio_monitor/user_database.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

/// Send health alert email to doctor
Future<void> sendAlertEmail(String report, String userEmail) async {
  //  Get user info from database
  final user = await UserDatabase.instance.getUserByEmail(userEmail);

  String name = user?['name'] ?? "Unknown User";
  String phone = user?['phone'] ?? "No Phone";

  // Configure your SMTP (Gmail) server
  final smtpServer = gmail(
    'biomonitor7829@gmail.com', // Your Gmail address
    'xwqllznzyimucegm', // Your Gmail App Password (do NOT use normal password)
  );

  //  Create the email message
  final message = Message()
    ..from = Address('biomonitor7829@gmail.com', 'Health Monitor App')
    ..recipients.add('aitizaz844@gmail.com') // Doctor's email
    ..subject = '⚠️ Health Alert from Patient'
    ..text = """
⚠️ HEALTH ALERT

Patient Name: $name
Phone Number: $phone
------------------------------------
HEALTH REPORT:
------------------------------------
$report
""";

  // 4️⃣ Send the email
  try {
    final sendReport = await send(message, smtpServer);
    print('Email sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Email send error: ${e.toString()}');
  } catch (e) {
    print('Unexpected email error: $e');
  }
}
