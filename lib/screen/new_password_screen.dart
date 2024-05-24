// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:raymay/screen/login_screen.dart';

// class NewPasswordScreen extends StatefulWidget {
//   final String token;

//   NewPasswordScreen({required this.token});

//   @override
//   _NewPasswordScreenState createState() => _NewPasswordScreenState();
// }

// class _NewPasswordScreenState extends State<NewPasswordScreen> {
//   TextEditingController passwordController = TextEditingController();
//   bool isPasswordComplete = false;

//   Future<void> resetPassword() async {
//     try {
//       final response = await http.post(
//         Uri.parse(
//             'https://rfqos.internal.engineerforce.io/api/v1/password_reset/confirm/'),
//         body: {
//           'token': widget.token,
//           'password': passwordController.text,
//         },
//       );

//       if (response.statusCode == 200) {
//         print('Password reset successfully');
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => Login()),
//         );
//       } else {
//         print('Failed to reset password. Status code: ${response.statusCode}');
//         // Handle failure, show error message, etc.
//       }
//     } catch (error) {
//       print('Error resetting password: $error');
//       // Handle error, show error message, etc.
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('New Password'),
//       ),
//       body: Center(
//         child: Container(
//           width: 500,
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Enter your new password',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: passwordController,
//                 obscureText: true,
//                 onChanged: (value) {
//                   setState(() {
//                     isPasswordComplete = value.isNotEmpty;
//                   });
//                 },
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'New Password',
//                 ),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: isPasswordComplete ? resetPassword : null,
//                 child: Text('Reset Password'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
