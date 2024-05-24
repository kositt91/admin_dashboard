import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex; // Define selectedIndex variable

  Sidebar({required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50, bottom: 50),
      width: 250, // Set the width of the sidebar
      color: Color(0xFF1C1E24), // Set the background color to match the image
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              onItemTapped(0);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 16, left: 16),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(10), // Adjust the radius as needed
                child: Container(
                  color: selectedIndex == 0 ? Colors.white : null,
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
                      child: Icon(Icons.list, size: 24, color: Colors.white),
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
                      child:
                          Text('注文一覧', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onItemTapped(1);
            },
            child: Padding(
              padding: EdgeInsets.only(
                  right: 16, left: 16), // Adjust the left padding as needed
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(10), // Adjust the radius as needed
                child: Container(
                  color: selectedIndex == 1 ? Colors.white : null,
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
                      child: Icon(Icons.drafts, size: 24, color: Colors.white),
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
                      child:
                          Text('下書き一覧', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          ListTile(
            leading: Icon(Icons.account_circle, color: Colors.white),
            title: Text('User Name', style: TextStyle(color: Colors.white)),
            onTap: () {
              onItemTapped(2);
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16), // Add left and right padding
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(10), // Adjust the radius as needed
                border: Border.all(color: Colors.white), // Add white border
              ),
              child: ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.white),
                title: Text('ログアウト', style: TextStyle(color: Colors.white)),
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
