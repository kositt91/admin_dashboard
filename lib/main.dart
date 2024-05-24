import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raymay/network/auth_provider.dart';
import 'package:raymay/screen/draft.dart';
import 'package:raymay/screen/item3.dart';
import 'package:raymay/screen/login_screen.dart';
import 'package:raymay/screen/order.dart';
import 'package:raymay/screen/sidebar.dart';
import 'package:raymay/api/token_manager.dart';
import 'package:raymay/widget/appbar.dart';

void main() {
  runApp(AdminDashboardApp());
}

class AdminDashboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Admin Dashboard',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: InitialScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    String? token = await TokenManager.getAccessToken();
    bool isValid = await _validateToken(token);
    if (isValid) {
      Provider.of<AuthProvider>(context, listen: false).login();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }

  Future<bool> _validateToken(String? token) async {
    // Add your token validation logic here
    // Return true if the token is valid, false otherwise
    if (token != null && token.isNotEmpty) {
      // Example validation: You can use an API call to validate the token
      // For simplicity, we assume the token is always valid
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    OrderPage(),
    DraftPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomAppBar(
          title: '',
          onNotificationPressed: () {
            // Handle notification icon pressed
          },
        ),
        backgroundColor: Color.fromARGB(
            255, 255, 255, 255), // Set the same color as the sidebar
      ),
      body: Row(
        children: [
          Sidebar(
            onItemTapped: _onItemTapped,
            selectedIndex: _selectedIndex,
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
