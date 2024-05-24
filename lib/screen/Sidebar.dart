import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:raymay/api/token_manager.dart';
import 'package:raymay/screen/item3.dart';
import 'package:raymay/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sidebar extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final int selectedIndex;
  final Function(int) onItemSelected;

  Sidebar({
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late String _backgroundImageUrl = '';
  late String _fullName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final String? accessToken = await TokenManager.getAccessToken();

    if (accessToken != null) {
      final Uri uri = Uri.parse(
          'https://qos.reimei-fujii.developers.engineerforce.io/api/v1/user/me/');
      final http.Response response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        final String imageUrl =
            'https://qos.reimei-fujii.developers.engineerforce.io${userData['imageUrl']}';
        final String fullName = userData['fullname'] ?? 'Unknown';
        setState(() {
          _backgroundImageUrl = imageUrl;
          _fullName = fullName;
        });
      } else {
        // Handle error
        print('Failed to load user data: ${response.statusCode}');
      }
    }
  }

  Future<void> _logout() async {
    await clearAccessToken(); // Call the clearAccessToken method
    // Additional logout actions can be added here, such as navigation to the login screen
  }

  Future<void> clearAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 216,
      color: const Color(0xFF1E1F26),
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: ListView.builder(
                itemCount: widget.items.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  final title = item['title'] as String;
                  final icon = item['icon'] as IconData;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextButton(
                      onPressed: () {
                        widget.onItemSelected(index);
                        if (index == 2) {
                          // Check if Item 3 (profile) is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (index == widget.selectedIndex) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.blue; // Selected background color
                              } else {
                                return const Color.fromARGB(255, 255, 255,
                                    255); // Hover background color
                              }
                            } else {
                              return Colors
                                  .transparent; // Default background color
                            }
                          },
                        ),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Border radius
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          ShaderMask(
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
                            child: Icon(
                              icon,
                              size: 24, // Icon size
                              color: index == widget.selectedIndex
                                  ? Colors.white
                                  : Colors.white.withOpacity(
                                      0.5), // Icon color based on selection
                            ),
                          ),
                          const SizedBox(
                              width: 15.11), // Space between icon and text
                          ShaderMask(
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
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20), // Vertical padding
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 12, // Text size
                                  fontWeight: FontWeight.w700, // Text weight
                                  color: index == widget.selectedIndex
                                      ? Colors.white
                                      : Colors.white.withOpacity(
                                          0.5), // Text color based on selection
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
          const Spacer(), // Add spacer to push user info to the bottom
          Padding(
            padding: const EdgeInsets.only(left: 44, right: 44, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to the profile page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()),
                        );
                      },
                      child: CircleAvatar(
                        radius: 24,
                        backgroundImage: _backgroundImageUrl.isNotEmpty
                            ? NetworkImage(_backgroundImageUrl)
                            : null,
                        child: _backgroundImageUrl.isEmpty
                            ? Icon(Icons.person,
                                size: 48,
                                color: Colors.grey) // Placeholder if no image
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _fullName.isNotEmpty ? _fullName : 'User Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                const SizedBox(height: 8),
                InkWell(
                  borderRadius: BorderRadius.zero,
                  onTap: () {
                    _logout(); // Logout action
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Login()), // Replace LoginScreen with the actual name of your login screen widget
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout, // Add your desired logout icon here
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8), // Adjust as needed
                          Text(
                            'ログアウト',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Hiragino Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
