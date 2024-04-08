import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raymay/network/auth_provider.dart';
import 'package:raymay/screen/dashboard_screen.dart';
import 'package:raymay/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<bool>(
        future: checkAuthenticationStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the result, display a loading indicator
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else {
            // Once the result is available, decide whether to show the login or dashboard screen
            if (snapshot.hasData && snapshot.data!) {
              // User is authenticated, show dashboard
              return DashboardScreen();
            } else {
              // User is not authenticated, show login
              return Login();
            }
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<bool> checkAuthenticationStatus() async {
  // Retrieve access token from storage (e.g., SharedPreferences)
  String? accessToken = await retrieveAccessToken();

  // Check if the access token is valid (you might need to check for expiration)
  bool isValidToken = accessToken != null && accessToken.isNotEmpty;

  return isValidToken;
}

Future<String?> retrieveAccessToken() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  } catch (e) {
    print('Error retrieving access token: $e');
    return null;
  }
}
