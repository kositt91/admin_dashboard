import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:raymay/api/token_manager.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userData = {};
  Uint8List? _imageBytes;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController groupsController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
        fullNameController.text = userData['fullname'] ?? '谷田 大空';
        groupsController.text = userData['groups']?.join(', ') ?? '○○部△△課';
        emailController.text = userData['email'] ?? 'sample@ex-mail.com';
        passwordController.text = '********';
      });
      print(userData); // Print user data to console
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        showDialog(
          context: context,
          barrierDismissible:
              false, // Prevent dismissing the dialog by tapping outside
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('画像のアップロード'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('画像のアップロード中...'),
                ],
              ),
            );
          },
        );

        final bytes = await pickedFile.readAsBytes();
        final multipartFile = http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: 'user_image.${pickedFile.path.split('.').last}',
        );

        final authToken = await TokenManager.getAccessToken();
        await _updateUserProfileImage(multipartFile, authToken!);

        setState(() {
          _imageBytes = bytes;
        });

        fetchData(); // Update user data after image upload
      } catch (error) {
        print('Error updating user profile image: $error');
      } finally {
        Navigator.of(context).pop(); // Close the uploading dialog
      }
    }
  }

  Future<void> _updateUserProfileImage(
      http.MultipartFile image, String authToken) async {
    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('https://rfqos.internal.engineerforce.io/api/v1/user/me/'),
      );

      request.headers['Authorization'] = 'Bearer $authToken';
      request.files.add(http.MultipartFile(
        'image',
        image.finalize(), // Use finalize() to get the ByteStream
        image.length,
        filename: 'user_image.jpg',
      ));
      final response = await request.send();

      if (response.statusCode == 200) {
        print('User profile image updated successfully');
      } else {
        print(
            'Failed to update user profile image. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating user profile image: $error');
    }
  }

  void _showEditUserNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('名前を編集する'),
          content: TextField(
            controller: fullNameController,
            decoration: const InputDecoration(
              hintText: 'フルネーム',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () async {
                String fullName = fullNameController.text.trim();

                if (fullName.isNotEmpty) {
                  await updateUserName(fullName);
                  Navigator.of(context).pop();
                } else {
                  // Show an error message if either field is empty
                  // You can customize this message according to your requirements
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('フルネームを入力してください'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateUserName(String fullName) async {
    final authToken = await TokenManager.getAccessToken();
    final response = await http.put(
      Uri.parse('https://rfqos.internal.engineerforce.io/api/v1/user/me/'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'fullname': fullName}),
    );

    if (response.statusCode == 200) {
      setState(() {
        userData['fullname'] = fullName;
      });
      print('User name updated successfully');
    } else {
      print('Failed to update user name. Status code: ${response.statusCode}');
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
                        backgroundImage: _imageBytes != null
                            ? MemoryImage(_imageBytes!)
                            : userData['imageUrl'] != null
                                ? NetworkImage(
                                    'https://rfqos.internal.engineerforce.io${userData['imageUrl']}')
                                : AssetImage('assets/profile_picture.png')
                                    as ImageProvider,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _pickImage,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '名前',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: _showEditUserNameDialog,
                              child: Container(
                                width: 800,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                child: Text(
                                  fullNameController.text,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          '所属部署',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: '',
                            border: OutlineInputBorder(),
                          ),
                          enabled: false,
                          controller: groupsController,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'メールアドレス',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: '',
                            border: OutlineInputBorder(),
                          ),
                          enabled: false,
                          controller: emailController,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'パスワード',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: '',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          enabled: false,
                          controller: passwordController,
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            // Implement password change functionality
                          },
                          child: Text(
                            'パスワードを変更する',
                            style: TextStyle(
                              color: Color.fromARGB(255, 62, 12, 241),
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
