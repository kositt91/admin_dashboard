import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onNotificationPressed;

  CustomAppBar({
    required this.title,
    required this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey, // Adjust the color as needed
            width: 1.0, // Adjust the width as needed
          ),
        ),
      ),
      child: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Image.asset(
                'assets/images/logo.png', // Replace with your logo image path
                height: 33.0,
                width: 70.0,
              ),
            ),
            SizedBox(width: 8.0), // Adjust the spacing between logo and title
            Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
