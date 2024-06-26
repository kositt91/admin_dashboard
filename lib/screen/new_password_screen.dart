import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:raymay/api/token_manager.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool showCurrentPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;
  Future<void> changePassword(
      String currentPassword, String newPassword, String? refreshToken) async {
    try {
      // Use the provided refresh token or get it from SharedPreferences
      final token = refreshToken ?? await TokenManager.getRefreshToken();

      // Get the access token
      final accessToken = await TokenManager.getAccessToken();

      // Make a request to change the password
      final response = await http.post(
        Uri.parse(
            'https://rfqos.internal.engineerforce.io/api/v1/user/change-password/'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'oldPassword':
              currentPassword, // Provide the user's current password here
          'newPassword': newPassword,
          'refresh': token,
        }),
      );

      if (response.statusCode == 200) {
        // Password changed successfully
        if (kDebugMode) {
          print('Password changed successfully!');
        }
      } else {
        // Handle error response
        if (kDebugMode) {
          print('Error changing password: ${response.body}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error changing password: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(right: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.chevron_left,
                        size: 20,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'マイページに戻る',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'パスワードの変更',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 480, // Set a fixed width for the text field
                  child: buildPasswordTextField(
                    '現在のパスワードを入力してください',
                    currentPasswordController,
                    showCurrentPassword,
                    () {
                      setState(() {
                        showCurrentPassword = !showCurrentPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 480, // Set a fixed width for the text field
                  child: buildPasswordTextField(
                    '新しいパスワードを入力してください',
                    newPasswordController,
                    showNewPassword,
                    () {
                      setState(() {
                        showNewPassword = !showNewPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 480, // Set a fixed width for the text field
                  child: buildPasswordTextField(
                    '確認のためもう一度入力してください',
                    confirmPasswordController,
                    showConfirmPassword,
                    () {
                      setState(() {
                        showConfirmPassword = !showConfirmPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.only(left: 320),
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        final currentPassword = currentPasswordController.text;
                        final newPassword = newPasswordController.text;
                        final confirmPassword = confirmPasswordController.text;

                        if (newPassword == confirmPassword) {
                          final refreshToken = await TokenManager
                              .getRefreshToken(); // Get the actual refresh token
                          await changePassword(
                              currentPassword, newPassword, refreshToken);
                        } else {
                          // Passwords do not match
                          if (kDebugMode) {
                            print('Passwords do not match');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 10, 8, 124),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'パスワードを変更',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordTextField(
    String title,
    TextEditingController controller,
    bool showPassword,
    VoidCallback toggleShowPassword,
  ) {
    return buildDetailWithTitleOutsideBox(
      title,
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: !showPassword,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: title,
              ),
              autofillHints: const [],
            ),
          ),
          IconButton(
            icon: Icon(
              showPassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: toggleShowPassword,
          ),
        ],
      ),
    );
  }

  Widget buildDetailWithTitleOutsideBox(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              color: const Color.fromARGB(54, 35, 19, 19),
              width: 1.0,
            ),
          ),
          child: child,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
