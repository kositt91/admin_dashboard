import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raymay/api/api_service.dart';
import 'package:raymay/api/token_manager.dart';
import 'package:raymay/main.dart';
import 'package:raymay/network/auth_provider.dart';
import 'package:raymay/screen/forgot.dart';
import 'package:raymay/widget/appbar.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    setState(() {
      _loading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Create an instance of ApiService
      ApiService apiService =
          ApiService('https://rfqos.internal.engineerforce.io/api/v1/login/');

      // Call the login method on the instance
      final response = await apiService.login(email, password);

      // Assuming the API response contains an access token
      final accessToken = response['access'];

      // Save the access token
      await TokenManager.saveAccessToken(accessToken);

      // Update the authentication state
      Provider.of<AuthProvider>(context, listen: false).login();

      // Navigate to the user details screen or perform other actions on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(),
        ),
      );
    } catch (e) {
      // Handle login failure
      print('Login failed: $e');
      // Show an error message or handle the error as needed
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: '',
          onNotificationPressed: () {
            // Handle notification icon pressed
          },
        ),
        body: Center(
            child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 600,
                width: 480,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/login.png'))),
              ),
              Container(
                height: 600,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: Color.fromARGB(255, 212, 210, 210)!,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Container(
                          height: 105,
                          width: 222,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/logo.png'), // Replace with your logo image path
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Container(
                          child: Text("管理画面ログイン"),
                        ),
                        SizedBox(height: 20),

                        // Username title
                        Container(
                          alignment: Alignment.centerLeft,
                          width: 350,
                          child: Text(
                            'ユーザーネーム',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Username field
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24.0, right: 24.0, top: 8),
                          child: Container(
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromARGB(
                                      255, 182, 180, 180)), // Add border
                              borderRadius: BorderRadius.circular(
                                  8), // Optional: Add border radius
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.people_alt,
                                  color: Colors.grey,
                                ),
                                border:
                                    InputBorder.none, // Remove default border
                                hintText: 'ユーザーネーム',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Password title
                        Container(
                          width: 350,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'パスワード',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Password field with border
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24.0, right: 24.0, top: 8),
                          child: Container(
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromARGB(
                                      255, 182, 180, 180)), // Add border
                              borderRadius: BorderRadius.circular(
                                  8), // Optional: Add border radius
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                                border:
                                    InputBorder.none, // Remove default border
                                hintText: 'パスワード',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                              ),
                            ),
                          ),
                        ),

                        // Forget password
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 34),
                        //   child: InkWell(
                        //     onTap: () {
                        //       // Navigate to the Forgot Password screen
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => ForgotPasswordScreen(),
                        //         ),
                        //       );
                        //     },
                        //     child: const Text(
                        //       'パスワードを忘れた場合',
                        //       style: TextStyle(
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.w300,
                        //         color: Color.fromARGB(255, 25, 7, 139),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        SizedBox(
                          width: 200,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 35.0),
                            child: ElevatedButton(
                              onPressed: _loading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 40, 41, 131),
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  bottom: 20,
                                ),
                              ),
                              child: _loading
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : const Text(
                                      'ログイン',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )));
  }
}
