// //wrong.dart
//
// import 'package:flutter/material.dart';
//
// class HomePage extends StatelessWidget {
//   final Map<String, dynamic> userData;
//   HomePage({required this.userData});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Welcome ${userData['name']}"),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("User Details",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             Text("Name: ${userData['name']}"),
//             Text("Email: ${userData['email']}"),
//             Text("Phone: ${userData['phone']}"),
//             Text("Date of Birth: ${userData['dob']}"),
//             Text("Gender: ${userData['gender']}"),
//             Text("Blood Group: ${userData['blood']}"),
//             SizedBox(height: 40),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context); // logout
//                 },
//                 child: Text("Logout"),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
