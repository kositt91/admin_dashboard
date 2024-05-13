import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  bool isEmailComplete = false;

  Future<void> sendPasswordResetLink() async {
    try {
      // Step 1: Request password reset link
      final response1 = await http.post(
        Uri.parse(
            'https://qos.reimei-fujii.developers.engineerforce.io/api/v1/password-reset/'),
        body: {'email': emailController.text},
      );

      if (response1.statusCode == 200) {
        print('Password reset link sent successfully');

        // Show confirmation dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('パスワードリセット'),
              content: Text('リセットリンクを送信しました。メールを確認してください。'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print(
            'Failed to send password reset link. Status code: ${response1.statusCode}');
        // Handle failure, show error message, etc.
      }
    } catch (error) {
      print('Error sending password reset link: $error');
      // Handle error, show error message, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        // Add your app bar title here
        actions: [
          // Add app bar actions if needed
        ],
      ),
      body: Center(
        child: Container(
          width: 500,
          height: 500,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 182, 180, 180),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'パスワード再設定',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'メールアドレスを入力してください。',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'パスワード再設定のためのリンクを送信します。',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Container(
                child: Text("メールアドレス"),
              ),
              Container(
                width: 350,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(255, 182, 180, 180),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  controller: emailController,
                  onChanged: (value) {
                    setState(() {
                      isEmailComplete = value.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'メールアドレス',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isEmailComplete ? sendPasswordResetLink : null,
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 40, 41, 131),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  minimumSize: Size(360, 0),
                ),
                child: Text(
                  'リセットリンクを送信する',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
