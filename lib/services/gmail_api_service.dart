// lib/services/gmail_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendMishapEmailWithGmailAPI(
    String accessToken,
    String fromEmail,
    String toEmail,
    String report
    ) async {
  final String rawMessage = '''
From: $fromEmail
To: $toEmail
Subject: ⚠️ Health Mishap Detected

$report
''';

  final String base64Message = base64Url.encode(utf8.encode(rawMessage));

  final response = await http.post(
    Uri.parse('https://gmail.googleapis.com/gmail/v1/users/me/messages/send'),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: '{"raw":"$base64Message"}',
  );

  if (response.statusCode == 200) {
    print("Email sent successfully!");
  } else {
    print("Failed to send email: ${response.body}");
  }
}
