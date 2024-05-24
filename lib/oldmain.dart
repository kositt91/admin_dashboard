// import 'package:flutter/foundation.dart'; // Add this import for kIsWeb
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:raymay/network/auth_provider.dart';
// import 'package:raymay/screen/dashboard_screen.dart';
// import 'package:raymay/screen/login_screen.dart';
// import 'package:raymay/screen/new_password_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uni_links/uni_links.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => AuthProvider(),
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     if (!kIsWeb) {
//       initUniLinks();
//     }
//   }

//   Future<void> initUniLinks() async {
//     try {
//       final initialLink = await getInitialLink();
//       if (initialLink != null) {
//         _handleIncomingLink(initialLink);
//       }
//       linkStream.listen((String? link) {
//         if (link != null) {
//           _handleIncomingLink(link);
//         }
//       });
//     } catch (e) {
//       print('Error initializing uni links: $e');
//     }
//   }

//   void _handleIncomingLink(String link) {
//     print('Incoming link: $link');
//     final uri = Uri.parse(link);
//     print('Parsed URI: $uri');
//     if (uri.pathSegments.contains('password_reset') &&
//         uri.pathSegments.contains('confirm') &&
//         uri.queryParameters.containsKey('token')) {
//       final token = uri.queryParameters['token']!;
//       print('Token: $token');
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => NewPasswordScreen(token: token),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: FutureBuilder<bool>(
//         future: checkAuthenticationStatus(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Scaffold(body: Center(child: CircularProgressIndicator()));
//           } else {
//             if (snapshot.hasData && snapshot.data!) {
//               return DashboardScreen();
//             } else {
//               return Login();
//             }
//           }
//         },
//       ),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// Future<bool> checkAuthenticationStatus() async {
//   String? accessToken = await retrieveAccessToken();
//   bool isValidToken = accessToken != null && accessToken.isNotEmpty;
//   return isValidToken;
// }

// Future<String?> retrieveAccessToken() async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('access_token');
//   } catch (e) {
//     print('Error retrieving access token: $e');
//     return null;
//   }
// }
