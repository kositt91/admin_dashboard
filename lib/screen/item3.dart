import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:raymay/api/token_manager.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final authToken = await TokenManager.getAccessToken();
    final response = await http.get(
      Uri.parse('https://rfqos.internal.engineerforce.io/api/v1/user/me/'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      setState(() {
        userData = json.decode(utf8.decode(response.bodyBytes));
      });
      print(userData); // Print user data to console
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('マイページ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Container(
          padding: const EdgeInsets.only(top: 50, left: 50, right: 700),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile picture and button
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: userData['imageUrl'] != null
                            ? NetworkImage(
                                    'https://rfqos.internal.engineerforce.io${userData['imageUrl']}')
                                as ImageProvider
                            : AssetImage('assets/profile_picture.png')
                                as ImageProvider,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Implement profile picture change functionality
                        },
                        child: Text('画像を設定する'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(20),
                          side: BorderSide(
                              color: Color.fromARGB(255, 76, 71, 150),
                              width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  // Text fields
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: '名前',
                            border: OutlineInputBorder(),
                          ),
                          controller: TextEditingController(
                            text: userData['fullname'] ?? '谷田 大空',
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            labelText: '所属部署',
                            border: OutlineInputBorder(),
                          ),
                          controller: TextEditingController(
                            text: userData['groups']?.join(', ') ?? '○○部△△課',
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'メールアドレス',
                            border: OutlineInputBorder(),
                          ),
                          controller: TextEditingController(
                            text: userData['email'] ?? 'sample@ex-mail.com',
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'パスワード',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          controller: TextEditingController(
                            text: '********', // Placeholder password
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            // Implement password change functionality
                          },
                          child: Text(
                            'パスワードを変更する',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}
