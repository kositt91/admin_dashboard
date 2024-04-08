import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:raymay/api/token_manager.dart';
import 'package:raymay/screen/Item1.dart';
import 'package:raymay/screen/Item2.dart';
import 'package:raymay/screen/Sidebar.dart';
import 'package:raymay/widget/appbar.dart'; // Assuming you have an app bar widget

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentPage = 1;
  String _searchText = '';
  int _selectedIndex = 0;
  List<Map<String, dynamic>> sampleData = []; // Initialize sampleData here

  List<Map<String, dynamic>> sidebarItems = [
    {'title': '注文一覧', 'icon': Icons.list_alt_outlined},
    {'title': '下書き一覧', 'icon': Icons.file_copy},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        onNotificationPressed: () {
          // Handle notification icon pressed
        },
      ),
      body: Row(
        children: [
          SizedBox(
            height: 44,
          ),
          Expanded(
            flex: 1,
            child: Sidebar(
              items: sidebarItems,
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _currentPage = index + 1;
                  _selectedIndex = index;
                });
              },
            ),
          ),
          Expanded(
            flex: 4,
            child: _currentPage == 1
                ? Item1(sampleData: sampleData)
                : Item2(sampleData: sampleData),
          ),
        ],
      ),
    );
  }
}
