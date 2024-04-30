import 'package:flutter/material.dart';
import 'package:raymay/widget/appbar.dart';

class ForgotPasswordScreen extends StatelessWidget {
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
                onPressed: () {
                  // Implement password reset logic here
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
                },
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
