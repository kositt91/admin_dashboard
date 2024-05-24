import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:raymay/api/token_manager.dart';
import 'package:http/http.dart' as http;

class Sidebar extends StatefulWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const Sidebar({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  Map<String, dynamic>? userData;

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
    return Container(
      padding: EdgeInsets.only(top: 50, bottom: 50),
      width: 250, // Set the width of the sidebar
      color: Color(0xFF1C1E24), // Set the background color to match the image
      child: userData == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    widget.onItemTapped(0);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 16, left: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          10), // Adjust the radius as needed
                      child: Container(
                        color: widget.selectedIndex == 0 ? Colors.white : null,
                        // Change background color based on selection
                        child: ListTile(
                          leading: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF202284),
                                  Color(0xFFAB7CAE),
                                ],
                              ).createShader(bounds);
                            },
                            child:
                                Icon(Icons.list, size: 24, color: Colors.white),
                          ),
                          title: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF202284),
                                  Color(0xFFAB7CAE),
                                ],
                              ).createShader(bounds);
                            },
                            child: Text('注文一覧',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.onItemTapped(1);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: 16,
                        left: 16), // Adjust the left padding as needed
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          10), // Adjust the radius as needed
                      child: Container(
                        color: widget.selectedIndex == 1 ? Colors.white : null,
                        // Change background color based on selection
                        child: ListTile(
                          leading: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF202284),
                                  Color(0xFFAB7CAE),
                                ],
                              ).createShader(bounds);
                            },
                            child: Icon(Icons.drafts,
                                size: 24, color: Colors.white),
                          ),
                          title: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF202284),
                                  Color(0xFFAB7CAE),
                                ],
                              ).createShader(bounds);
                            },
                            child: Text('下書き一覧',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: userData != null &&
                            userData!['imageUrl'] != null
                        ? NetworkImage(
                            'https://rfqos.internal.engineerforce.io${userData!['imageUrl']}')
                        : null,
                    child: userData != null && userData!['imageUrl'] == null
                        ? Icon(Icons.account_circle, color: Colors.white)
                        : null,
                  ),
                  title: Text(userData?['fullname'] ?? 'User Name',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  onTap: () {
                    widget.onItemTapped(2);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16), // Add left and right padding
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          10), // Adjust the radius as needed
                      border:
                          Border.all(color: Colors.white), // Add white border
                    ),
                    child: ListTile(
                      leading: Icon(Icons.exit_to_app, color: Colors.white),
                      title:
                          Text('ログアウト', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // Handle logout action
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
