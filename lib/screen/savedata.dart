import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SavedDataPage extends StatefulWidget {
  final List<Map<String, dynamic>> filteredData;
  final String startDate;
  final String endDate;
  final String startDateShip;
  final String endDateShip;
  final String clientName;
  final String userName;

  SavedDataPage({
    required this.filteredData,
    required this.startDate,
    required this.endDate,
    required this.startDateShip,
    required this.endDateShip,
    required this.clientName,
    required this.userName,
  });

  @override
  _SavedDataPageState createState() => _SavedDataPageState();
}

class _SavedDataPageState extends State<SavedDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Data'),
      ),
      body: ListView.builder(
        itemCount: widget.filteredData.length + 1, // Add 1 for the header
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('User Name: ${widget.userName}'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Client Name: ${widget.clientName}'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Start Date: ${widget.startDate}'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('End Date: ${widget.endDate}'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Start Date Ship: ${widget.startDateShip}'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('End Date Ship: ${widget.endDateShip}'),
              ),
            ],
          );
        },
      ),
    );
  }
}
