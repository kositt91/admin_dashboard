import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(int) onItemTapped;

  Sidebar({required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      width: 250, // Set the width of the sidebar
      color: Color(0xFF1C1E24), // Set the background color to match the image
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.list, color: Colors.white),
            title: Text('注文一覧', style: TextStyle(color: Colors.white)),
            onTap: () {
              onItemTapped(0);
            },
          ),
          ListTile(
            leading: Icon(Icons.drafts, color: Colors.white),
            title: Text('下書き一覧', style: TextStyle(color: Colors.white)),
            onTap: () {
              onItemTapped(1);
            },
          ),
          Spacer(),
          ListTile(
            leading: Icon(Icons.account_circle, color: Colors.white),
            title: Text('User Name', style: TextStyle(color: Colors.white)),
            onTap: () {
              onItemTapped(2);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.white),
            title: Text('ログアウト', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Handle logout action
            },
          ),
        ],
      ),
    );
  }
}
