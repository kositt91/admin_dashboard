import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:raymay/api/token_manager.dart';
import 'package:raymay/screen/savedata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FilterWidget extends StatefulWidget {
  final void Function(List<Map<String, dynamic>> filteredData) onFilterApplied;

  FilterWidget({
    required this.onFilterApplied,
    required List<Map<String, dynamic>> sampleData,
  });

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startDateControllership = TextEditingController();
  TextEditingController endDateControllership = TextEditingController();
  TextEditingController clientNameController =
      TextEditingController(); // Add controller for client name
  TextEditingController userNameController =
      TextEditingController(); // Add controller for user name
  List<Map<String, dynamic>> sampleData = [];

  @override
  void initState() {
    super.initState();
    // Call fetchData() when the widget is initialized
    fetchData();
    print('Fetching data...');
  }

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    clientNameController.dispose(); // Dispose of client name controller
    userNameController.dispose(); // Dispose of user name controller
    super.dispose();
  }

  Future<void> saveFilteredDataLocally(
      List<Map<String, dynamic>> filteredData,
      String startDate,
      String endDate,
      String startDateShip,
      String endDateShip,
      String clientName,
      String userName,
      BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (filteredData.isNotEmpty) {
      // Convert the list of maps to a JSON string
      String jsonData = jsonEncode({
        'filteredData': filteredData,
        'startDate': startDate,
        'endDate': endDate,
        'startDateShip': startDateShip,
        'endDateShip': endDateShip,
        'clientName': clientName,
        'userName': userName,
      });

      // Save the JSON string to SharedPreferences
      await prefs.setString('filteredData', jsonData);
      print('Filtered data and selected dates saved locally');

      // Print the saved data structure
      String? savedDataJson = prefs.getString('filteredData');
      if (savedDataJson != null) {
        print('Saved data structure:');
        print(savedDataJson);
      } else {
        print('No saved data found.');
      }

      // Navigate to the SavedDataPage after saving the data
    } else {
      print('No filtered data to save.');
      // You can handle this case as needed, such as showing a message to the user
    }
  }

  Future<void> fetchData() async {
    final authToken = await TokenManager.getAccessToken();
    final Uri uri = Uri.parse(
        'https://qos.reimei-fujii.developers.engineerforce.io/api/v1/user/admin-orders/');
    final Map<String, String> headers = {
      'Authorization': 'Bearer $authToken',
    };

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty && data[0] is List) {
          // Check if data is not empty and is a list
          setState(() {
            sampleData =
                data[0].cast<Map<String, dynamic>>(); // Access the inner list
            // Print the fetched data
            print('Fetched data: $sampleData');
          });
          // Delete the saved filtered data
          await deleteSavedDataLocally();
        } else {
          throw Exception('Data is not in the expected format');
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Error fetching data');
    }
  }

  // Method to delete saved filtered data
  Future<void> deleteSavedDataLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Remove the filteredData key from SharedPreferences
    await prefs.remove('filteredData');
    print('Saved filtered data deleted');
  }

  // Add filtering options and logic here
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 0,
          top: 200,
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      '',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'クライアント',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Autocomplete<Map<String, dynamic>>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  // If no text is entered, return an empty list
                                  if (textEditingValue.text.isEmpty) {
                                    return [];
                                  }

                                  // Set to keep track of unique client names
                                  Set<String> uniqueClientNames = {};

                                  // Filter the sampleData list based on the text entered
                                  return sampleData
                                      .where((Map<String, dynamic> option) {
                                    final clientName = option['customer']
                                                ?['clientName']
                                            ?.toLowerCase() ??
                                        '';
                                    return clientName.contains(textEditingValue
                                            .text
                                            .toLowerCase()) &&
                                        uniqueClientNames.add(
                                            clientName); // Add to set and check for uniqueness
                                  }).toList(); // Convert Iterable to List for Autocomplete
                                },
                                displayStringForOption:
                                    (Map<String, dynamic> option) =>
                                        option['customer']['clientName'],
                                fieldViewBuilder: (
                                  BuildContext context,
                                  TextEditingController textEditingController,
                                  FocusNode focusNode,
                                  VoidCallback onFieldSubmitted,
                                ) {
                                  return TextField(
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Client Name',
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        // Update the state with the new value if needed
                                      });
                                    },
                                  );
                                },
                                onSelected: (Map<String, dynamic> selection) {
                                  // Handle the selection
                                  String selectedClientName =
                                      selection['customer']['clientName']
                                          .toString();
                                  clientNameController.text =
                                      selectedClientName;
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '発注者           ',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Autocomplete<Map<String, dynamic>>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  // If no text is entered, return an empty list
                                  if (textEditingValue.text.isEmpty) {
                                    return [];
                                  }

                                  // Set to keep track of unique client names
                                  Set<String> uniqueClientNames = {};

                                  // Filter the sampleData list based on the text entered
                                  return sampleData
                                      .where((Map<String, dynamic> option) {
                                    final clientName = option['user']?['name']
                                            ?.toLowerCase() ??
                                        '';
                                    return clientName.contains(textEditingValue
                                            .text
                                            .toLowerCase()) &&
                                        uniqueClientNames.add(
                                            clientName); // Add to set and check for uniqueness
                                  }).toList(); // Convert Iterable to List for Autocomplete
                                },
                                displayStringForOption:
                                    (Map<String, dynamic> option) =>
                                        option['user']['name'],
                                fieldViewBuilder: (
                                  BuildContext context,
                                  TextEditingController textEditingController,
                                  FocusNode focusNode,
                                  VoidCallback onFieldSubmitted,
                                ) {
                                  return TextField(
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Name',
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        // Update the state with the new value if needed
                                      });
                                    },
                                  );
                                },
                                onSelected: (Map<String, dynamic> selection) {
                                  // Handle the selection
                                  String selectedUserName =
                                      selection['user']['name'].toString();
                                  userNameController.text = selectedUserName;
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '注文日時       ',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final DateTime? pickedDate =
                                      await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      startDateController.text =
                                          DateFormat('yyyy/MM/dd')
                                              .format(pickedDate);
                                    });
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: startDateController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: 'Start Date',
                                      suffixIcon: Icon(Icons.calendar_today),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '   〜   ',
                              style: TextStyle(
                                fontSize: 23.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final List<String> dateComponents =
                                      startDateController.text.split('/');
                                  if (dateComponents.length == 3) {
                                    final int year =
                                        int.tryParse(dateComponents[0]) ??
                                            DateTime.now().year;
                                    final int month =
                                        int.tryParse(dateComponents[1]) ??
                                            DateTime.now().month;
                                    final int day =
                                        int.tryParse(dateComponents[2]) ??
                                            DateTime.now().day;

                                    final DateTime initialDate =
                                        DateTime(year, month, day);

                                    final DateTime? pickedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: initialDate,
                                      firstDate: initialDate,
                                      lastDate: DateTime(2100),
                                    );

                                    if (pickedDate != null) {
                                      setState(() {
                                        endDateController.text =
                                            DateFormat('yyyy/MM/dd')
                                                .format(pickedDate);
                                      });
                                    }
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: endDateController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: 'End Date',
                                      suffixIcon: Icon(Icons.calendar_today),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Text(
                              '希望納品日   ',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final DateTime? pickedDate =
                                      await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      startDateControllership.text =
                                          DateFormat('yyyy/MM/dd')
                                              .format(pickedDate);
                                    });
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: startDateControllership,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: 'Start Date',
                                      suffixIcon: Icon(Icons.calendar_today),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '   〜   ',
                              style: TextStyle(
                                fontSize: 23.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final List<String> dateComponents =
                                      startDateControllership.text.split('/');
                                  if (dateComponents.length == 3) {
                                    final int year =
                                        int.tryParse(dateComponents[0]) ??
                                            DateTime.now().year;
                                    final int month =
                                        int.tryParse(dateComponents[1]) ??
                                            DateTime.now().month;
                                    final int day =
                                        int.tryParse(dateComponents[2]) ??
                                            DateTime.now().day;

                                    final DateTime initialDate =
                                        DateTime(year, month, day);

                                    final DateTime? pickedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: initialDate,
                                      firstDate: initialDate,
                                      lastDate: DateTime(2100),
                                    );

                                    if (pickedDate != null) {
                                      setState(() {
                                        endDateControllership.text =
                                            DateFormat('yyyy/MM/dd')
                                                .format(pickedDate);
                                      });
                                    }
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: endDateControllership,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: 'End Date',
                                      suffixIcon: Icon(Icons.calendar_today),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Other rows for filtering options...
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.only(right: 16, bottom: 16),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF202284),
                              Color(0xFFAB7CAE),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            // Define and populate filteredData based on the filter criteria
                            List<Map<String, dynamic>> filteredData =
                                sampleData.where((data) {
                              // Retrieve the text entered in the Autocomplete fields
                              String clientName =
                                  clientNameController.text.toLowerCase();
                              String userName =
                                  userNameController.text.toLowerCase();

                              // Add your filtering logic here based on the text fields and date pickers
                              // For example, check if clientName contains the entered text
                              return data['customer']['clientName']
                                      .toString()
                                      .toLowerCase()
                                      .contains(clientName) &&
                                  data['user']['name']
                                      .toString()
                                      .toLowerCase()
                                      .contains(userName);
                            }).toList();

                            // Get the selected dates
                            String clientName = clientNameController.text;

                            String userName = userNameController.text;
                            String startDate = startDateController.text;
                            String endDate = endDateController.text;
                            String startDateShip = startDateControllership.text;
                            String endDateShip = endDateControllership.text;

                            // Pass filteredData and selected dates to the saveFilteredDataLocally method
                            await saveFilteredDataLocally(
                                filteredData,
                                startDate,
                                endDate,
                                startDateShip,
                                endDateShip,
                                clientName,
                                userName, // Corrected variable name
                                context);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          child: Text(
                            '検索する',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
