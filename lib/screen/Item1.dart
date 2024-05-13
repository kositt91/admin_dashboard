import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:raymay/api/token_manager.dart';
import 'package:intl/intl.dart';
import 'package:raymay/screen/filter_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart'; // Import open_file package
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:universal_html/html.dart' as uh;

class Item1 extends StatefulWidget {
  final void Function(List<Map<String, dynamic>> filteredData) onFilterApplied;
  List<Map<String, dynamic>> sampleData;

  Item1({required this.sampleData, required this.onFilterApplied});

  @override
  _Item1State createState() => _Item1State();
}

class _Item1State extends State<Item1> {
  List<Map<String, dynamic>> searchData = [];
  int _rowsPerPage = 10; // Number of rows per page
  int _currentPage = 1; // Current page number
  int _upperLimit = 10; // Default value for the upper limit
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startDateControllership = TextEditingController();
  TextEditingController endDateControllership = TextEditingController();
  TextEditingController clientNameController =
      TextEditingController(); // Add controller for client name
  TextEditingController userNameController =
      TextEditingController(); // Add controller for user name
  String _filterClientName = ''; // Initialize with an empty string
  DateTime? _filterOrderDate;
  List<Map<String, dynamic>> sampleData = [];
  String _searchInput = '';
  String _searchText = '';
  late List<Map<String, dynamic>> _filteredData;
  pw.Font? _notoSanFont;

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    loadFont();
    fetchData2();
    _filteredData = widget.sampleData;
    print('Fetching data...');
  }

  String calculateTotalPrice(Map<String, dynamic> data) {
    double totalPrice = 0;
    List<dynamic> products = data['products'];

    for (var product in products) {
      int quantity = product['quantity'] ?? 0;
      double unitPrice = product['productUnitPrice'] ?? 0.0;
      totalPrice += quantity * unitPrice;
    }

    // Format the total price without the dot and trailing zeros
    NumberFormat formatter = NumberFormat("#,##0.##", "en_US");
    return formatter.format(totalPrice);
  }

  Future<void> fetchData2() async {
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
        // Decode the response body using UTF-8 encoding
        String responseBody = utf8.decode(response.bodyBytes);
        List<dynamic> data = jsonDecode(responseBody);
        if (data.isNotEmpty && data[0] is List) {
          // Check if data is not empty and is a list
          setState(() {
            widget.sampleData =
                data[0].cast<Map<String, dynamic>>(); // Access the inner list
          });
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

  void changeRowsPerPage(int value) {
    setState(() {
      _rowsPerPage = value;
      _upperLimit = _currentPage * _rowsPerPage;
    });
  }

  Future<void> loadFont() async {
    ByteData fontData = await rootBundle.load("/fonts/notosan.ttf");
    setState(() {
      _notoSanFont = pw.Font.ttf(fontData);
    });
  }

  void navigateToPage(int page) {
    setState(() {
      _currentPage = page;
      _upperLimit = _currentPage * _rowsPerPage;
    });
  }

  List<Map<String, dynamic>> _filterData() {
    // Filter data based on search text and filter criteria
    return widget.sampleData.where((data) {
      // Check if any of the fields contain the search text
      bool containsSearchText = (data['customer']['clientName'] ?? '')
              .toLowerCase()
              .contains(_searchText.toLowerCase()) ||
          (data['created_at'] ?? '')
              .toLowerCase()
              .contains(_searchText.toLowerCase()) ||
          (data['customer']['shippingDate'] ?? '')
              .toLowerCase()
              .contains(_searchText.toLowerCase()) ||
          (data['user']['name'] ?? '')
              .toLowerCase()
              .contains(_searchText.toLowerCase());

      // Add additional conditions based on selected data from filter dialog
      if (clientNameController.text.isNotEmpty) {
        containsSearchText &= (data['customer']['clientName'] ?? '')
            .toLowerCase()
            .contains(clientNameController.text.toLowerCase());
      }
      if (userNameController.text.isNotEmpty) {
        containsSearchText &= (data['user']['name'] ?? '')
            .toLowerCase()
            .contains(userNameController.text.toLowerCase());
      }
      // Add conditions for other selected data from the dialog

      // Return true if data satisfies all filter conditions
      return containsSearchText;
    }).toList();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                                        return clientName.contains(
                                                textEditingValue.text
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
                                      TextEditingController
                                          textEditingController,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted,
                                    ) {
                                      return TextField(
                                        controller: textEditingController,
                                        focusNode: focusNode,
                                        decoration: InputDecoration(
                                          hintText: '',
                                        ),
                                        onChanged: (String value) {
                                          setState(() {
                                            _filterClientName = value;
                                          });
                                        },
                                      );
                                    },
                                    onSelected:
                                        (Map<String, dynamic> selection) {
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
                                        final clientName = option['user']
                                                    ?['name']
                                                ?.toLowerCase() ??
                                            '';
                                        return clientName.contains(
                                                textEditingValue.text
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
                                      TextEditingController
                                          textEditingController,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted,
                                    ) {
                                      return TextField(
                                        controller: textEditingController,
                                        focusNode: focusNode,
                                        decoration: InputDecoration(
                                          hintText: '',
                                        ),
                                        onChanged: (String value) {
                                          setState(() {
                                            // Update the state with the new value if needed
                                          });
                                        },
                                      );
                                    },
                                    onSelected:
                                        (Map<String, dynamic> selection) {
                                      // Handle the selection
                                      String selectedUserName =
                                          selection['user']['name'].toString();
                                      userNameController.text =
                                          selectedUserName;
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
                                          suffixIcon:
                                              Icon(Icons.calendar_today),
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
                                          suffixIcon:
                                              Icon(Icons.calendar_today),
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
                                          suffixIcon:
                                              Icon(Icons.calendar_today),
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
                                          startDateControllership.text
                                              .split('/');
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
                                          suffixIcon:
                                              Icon(Icons.calendar_today),
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
                              onPressed: () {
                                // Retrieve the text entered in the Autocomplete fields
                                String clientName =
                                    clientNameController.text.toLowerCase();
                                String userName =
                                    userNameController.text.toLowerCase();

                                // Filter data based on client name and user name
                                List<Map<String, dynamic>> filteredData =
                                    widget.sampleData.where((data) {
                                  String dataClientName =
                                      (data['customer']['clientName'] ?? '')
                                          .toString()
                                          .toLowerCase();
                                  String dataUserName =
                                      (data['user']['name'] ?? '')
                                          .toString()
                                          .toLowerCase();

                                  // Check if client name and user name contain the entered text
                                  return dataClientName.contains(clientName) &&
                                      dataUserName.contains(userName);
                                }).toList();

                                // Update the filtered data and close the dialog
                                setState(() {
                                  _filteredData = filteredData;
                                });
                                Navigator.of(context).pop();
                                // Close the dialog
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
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
      },
    );
  }

// Create a PDF document
  Future<void> _generateAndDownloadPDF(
      BuildContext context, Map<String, dynamic> draftDetail) async {
    try {
      // Create a PDF document
      final pdf = pw.Document();

      // Add content to the PDF document
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Container(
              // Adjust the width as needed
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(0.0),
                        child: pw.Text(
                          '注文内容詳細',
                          style: pw.TextStyle(
                            fontSize: 16.0,
                            fontWeight: pw.FontWeight.bold,
                            fontFallback: [
                              _notoSanFont ??
                                  pw.Font
                                      .helvetica(), // Use Helvetica as a fallback font
                            ], // Use the loaded font here
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 10.0),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text(
                              '発注者    ',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                fontFallback: [
                                  _notoSanFont ??
                                      pw.Font
                                          .helvetica(), // Use Helvetica as a fallback font
                                ],
                              ),
                            ),
                            pw.Text(
                              '${draftDetail['user']['name']}',
                              style: pw.TextStyle(
                                fontSize: 12.0,

                                fontFallback: [
                                  _notoSanFont ??
                                      pw.Font
                                          .helvetica(), // Use Helvetica as a fallback font
                                ],
                                decoration: pw.TextDecoration.underline,

                                decorationThickness:
                                    2.0, // Change to your desired thickness
                                decorationStyle:
                                    pw.TextDecorationStyle.solid, // E
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(
                          height: 10,
                        ),
                        pw.Row(
                          children: [
                            pw.Text(
                              'クライアント    ',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                fontWeight: pw.FontWeight.bold,
                                fontFallback: [
                                  _notoSanFont ??
                                      pw.Font
                                          .helvetica(), // Use Helvetica as a fallback font
                                ],
                              ),
                            ),
                            pw.Text(
                              '${draftDetail['customer']['clientName']}',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                fontWeight: pw.FontWeight.bold,

                                decoration: pw.TextDecoration.underline,
                                // Change to your desired color

                                decorationThickness:
                                    2.0, // Change to your desired thickness
                                decorationStyle: pw.TextDecorationStyle
                                    .solid, // Ensure the decoration is solid
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(
                          height: 10,
                        ),
                        pw.RichText(
                          text: pw.TextSpan(
                            children: [
                              pw.TextSpan(
                                text: '下書き合計金額  ',
                                style: pw.TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: pw.FontWeight.bold,
                                  fontFallback: [
                                    _notoSanFont ??
                                        pw.Font
                                            .helvetica(), // Use Helvetica as a fallback font
                                  ],
                                ),
                              ),
                              pw.TextSpan(
                                text:
                                    '  ¥  ${calculateTotalPrice(draftDetail)}',
                                style: pw.TextStyle(
                                  fontSize: 12.0, // Increase the font size
                                  fontWeight: pw.FontWeight
                                      .bold, // Apply bold font weight
                                  // Add any other styles you want
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(
                    height: 20,
                  ),
                  pw.Container(
                    width: 900,
                    child: pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColor.fromHex(
                            '#CCCCCC'), // Set border color to black
                        width: 1, // Set border width
                        style: pw.BorderStyle.solid, // Set border style
                      ), // Add borders to the table
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              color: PdfColor.fromHex('#CCCCCC'),
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                    child: pw.Text('得意先発注No',
                                        style: pw.TextStyle(
                                          fontFallback: [
                                            _notoSanFont ?? pw.Font.helvetica(),
                                            // Use Helvetica as a fallback font
                                          ],
                                        ))),
                              ),
                            ),
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              color: PdfColor.fromHex('#CCCCCC'),
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                    child: pw.Text('得意先コード',
                                        style: pw.TextStyle(
                                          fontFallback: [
                                            _notoSanFont ??
                                                pw.Font
                                                    .helvetica(), // Use Helvetica as a fallback font
                                          ],
                                        ))),
                              ),
                            ),
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              color: PdfColor.fromHex('#CCCCCC'),
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                    child: pw.Text('配達先',
                                        style: pw.TextStyle(
                                          fontFallback: [
                                            _notoSanFont ??
                                                pw.Font
                                                    .helvetica(), // Use Helvetica as a fallback font
                                          ],
                                        ))),
                              ),
                            ),
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              color: PdfColor.fromHex('#CCCCCC'),
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                    child: pw.Text('出荷指定日',
                                        style: pw.TextStyle(
                                          fontFallback: [
                                            _notoSanFont ??
                                                pw.Font
                                                    .helvetica(), // Use Helvetica as a fallback font
                                          ],
                                        ))),
                              ),
                            ),
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              color: PdfColor.fromHex('#CCCCCC'),
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                    child: pw.Text('電話番号',
                                        style: pw.TextStyle(
                                          fontFallback: [
                                            _notoSanFont ??
                                                pw.Font
                                                    .helvetica(), // Use Helvetica as a fallback font
                                          ],
                                        ))),
                              ),
                            ),
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              color: PdfColor.fromHex('#CCCCCC'),
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                    child: pw.Text('注文日時',
                                        style: pw.TextStyle(
                                          fontFallback: [
                                            _notoSanFont ??
                                                pw.Font
                                                    .helvetica(), // Use Helvetica as a fallback font
                                          ],
                                        ))),
                              ),
                            ),
                          ],
                        ),

                        // Add more TableRow as needed

                        pw.TableRow(
                          children: [
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                    child: pw.Text(
                                        '${draftDetail['customer']['orderNumber']}',
                                        style: pw.TextStyle(
                                          fontFallback: [
                                            _notoSanFont ??
                                                pw.Font
                                                    .helvetica(), // Use Helvetica as a fallback font
                                          ],
                                        ))),
                              ),
                            ),
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                    child: pw.Text(
                                        '${draftDetail['customer']['originalClientId']}',
                                        style: pw.TextStyle(
                                          fontFallback: [
                                            _notoSanFont ??
                                                pw.Font
                                                    .helvetica(), // Use Helvetica as a fallback font
                                          ],
                                        ))),
                              ),
                            ),
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                    child: pw.Text(
                                        '${draftDetail['customer']['deliveryMethod']}',
                                        style: pw.TextStyle(
                                          fontFallback: [
                                            _notoSanFont ??
                                                pw.Font
                                                    .helvetica(), // Use Helvetica as a fallback font
                                          ],
                                        ))),
                              ),
                            ),
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                  child: pw.Text(
                                      '${draftDetail['customer']['shippingDate']}' !=
                                              null
                                          ? DateFormat('yyyy/MM/dd').format(
                                              DateTime.parse(
                                                  draftDetail['customer']
                                                      ['shippingDate']))
                                          : '',
                                      style: pw.TextStyle(
                                        fontFallback: [
                                          _notoSanFont ??
                                              pw.Font
                                                  .helvetica(), // Use Helvetica as a fallback font
                                        ],
                                      ) // Format the shipping date if it exists, otherwise use an empty string
                                      ),
                                ),
                              ),
                            ),
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                    child: pw.Text(
                                        '${draftDetail['customer']['clientPhone']}',
                                        style: pw.TextStyle(
                                          fontFallback: [
                                            _notoSanFont ??
                                                pw.Font
                                                    .helvetica(), // Use Helvetica as a fallback font
                                          ],
                                        ))),
                              ),
                            ),
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                  child: pw.Text(
                                      DateFormat('yyyy/MM/dd').format(
                                          DateTime.parse(
                                              draftDetail['created_at'] ?? '')),
                                      style: pw.TextStyle(
                                        fontFallback: [
                                          _notoSanFont ??
                                              pw.Font
                                                  .helvetica(), // Use Helvetica as a fallback font
                                        ],
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Add more TableRow as needed
                      ],
                    ),
                  ),
                  pw.SizedBox(
                    height: 20,
                  ),
                  pw.Container(
                    width: 400,
                    child: pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColor.fromHex(
                            '#CCCCCC'), // Set border color to black
                        width: 1, // Set border width
                        style: pw.BorderStyle.solid,
                      ),
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Container(
                              // Background color for the cell
                              color: PdfColor.fromHex('#CCCCCC'),
                              alignment: pw.Alignment.center,
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                  child: pw.Text('お届け先',
                                      style: pw.TextStyle(
                                        fontFallback: [
                                          _notoSanFont ??
                                              pw.Font
                                                  .helvetica(), // Use Helvetica as a fallback font
                                        ],
                                      )),
                                ),
                              ),
                            ),
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              color: PdfColor.fromHex('#CCCCCC'),
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                  child: pw.Text(''),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Add more TableRow as needed

                        pw.TableRow(
                          children: [
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                  child: pw.Text(
                                    '〒  ${draftDetail['customer']['clientPhone']}',
                                    style: pw.TextStyle(
                                      fontFallback: [
                                        _notoSanFont ?? pw.Font.helvetica(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                  child: pw.Text(
                                    '${draftDetail['customer']['clientAddress']}',
                                    style: pw.TextStyle(
                                      fontFallback: [
                                        _notoSanFont ?? pw.Font.helvetica(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Add more TableRow as needed
                      ],
                    ),
                  ),
                  pw.Container(
                    width: 300,
                    child: pw.Padding(
                      padding: pw.EdgeInsets.only(top: 10),
                      child: pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(
                              color: PdfColor.fromHex(
                                  '#CCCCCC'), // Set border color to black
                              width: 1, // Set border width
                              style: pw.BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: pw.Text(
                          '備考   ${draftDetail['customer']['remark']}',
                          style: pw.TextStyle(
                            fontFallback: [
                              _notoSanFont ?? pw.Font.helvetica(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  pw.Container(
                    width: 300,
                    child: pw.Padding(
                      padding: pw.EdgeInsets.only(top: 10),
                      child: pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                              bottom: pw.BorderSide(
                            color: PdfColor.fromHex(
                                '#CCCCCC'), // Set border color to black
                            width: 1, // Set border width
                            style: pw.BorderStyle.solid,
                          )),
                        ),
                        child: pw.Text(
                          'コメント   ${draftDetail['customer']['comment']}',
                          style: pw.TextStyle(
                            fontFallback: [
                              _notoSanFont ?? pw.Font.helvetica(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Container(
                    width: 1000,

                    // Set the background color here
                    child: pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColor.fromHex(
                            '#CCCCCC'), // Set border color to black
                        width: 1, // Set border width
                        style: pw.BorderStyle.solid,
                      ), // Add borders to the tabler
                      children: [
                        // Table header
                        pw.TableRow(
                          children: [
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              color: PdfColor.fromHex('#CCCCCC'),
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                    child: pw.Text('JANコード',
                                        style: pw.TextStyle(
                                          fontFallback: [
                                            _notoSanFont ??
                                                pw.Font
                                                    .helvetica(), // Use Helvetica as a fallback font
                                          ],
                                        ))),
                              ),
                            ),
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              color: PdfColor.fromHex('#CCCCCC'),
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                    child: pw.Text('型番',
                                        style: pw.TextStyle(
                                          fontFallback: [
                                            _notoSanFont ??
                                                pw.Font
                                                    .helvetica(), // Use Helvetica as a fallback font
                                          ],
                                        ))),
                              ),
                            ),
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              color: PdfColor.fromHex('#CCCCCC'),
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                    child: pw.Text('品名',
                                        style: pw.TextStyle(
                                          fontFallback: [
                                            _notoSanFont ??
                                                pw.Font
                                                    .helvetica(), // Use Helvetica as a fallback font
                                          ],
                                        ))),
                              ),
                            ),
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              color: PdfColor.fromHex('#CCCCCC'),
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                    child: pw.Text('数量',
                                        style: pw.TextStyle(
                                          fontFallback: [
                                            _notoSanFont ??
                                                pw.Font
                                                    .helvetica(), // Use Helvetica as a fallback font
                                          ],
                                        ))),
                              ),
                            ),
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              color: PdfColor.fromHex('#CCCCCC'),
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                    child: pw.Text('価格',
                                        style: pw.TextStyle(
                                          fontFallback: [
                                            _notoSanFont ??
                                                pw.Font
                                                    .helvetica(), // Use Helvetica as a fallback font
                                          ],
                                        ))),
                              ),
                            ),
                            pw.Container(
                              // Background color for the cell
                              alignment: pw.Alignment.center,
                              color: PdfColor.fromHex('#CCCCCC'),
                              child: pw.SizedBox(
                                height: 25, // Adjust the height as needed
                                child: pw.Center(
                                    child: pw.Text('金額',
                                        style: pw.TextStyle(
                                          fontFallback: [
                                            _notoSanFont ??
                                                pw.Font
                                                    .helvetica(), // Use Helvetica as a fallback font
                                          ],
                                        ))),
                              ),
                            ),
                          ],
                        ),
// Table rows
                        for (var product in draftDetail['products'])
                          pw.TableRow(
                            decoration: pw.BoxDecoration(
                                // Add borders to the row
                                ),
                            children: [
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.all(8.0),
                                  child: pw.Text(product['productJan'] ?? ''),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.all(8.0),
                                  child: pw.Text(product['productCode'] ?? ''),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.all(8.0),
                                  child: pw.Text(product['productName'] ?? ''),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.all(8.0),
                                  child: pw.Text(
                                      product['quantity']?.toString() ?? ''),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.all(8.0),
                                  child: pw.Text(
                                      product['productUnitPrice']?.toString() ??
                                          ''),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.all(8.0),
                                  child: pw.Text(
                                    ((product['quantity'] ?? 0) *
                                            (product['productUnitPrice'] ?? 0))
                                        .toString(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 16.0),
                ],
              ),
            );
          },
        ),
      );

      // Save the PDF document to a Uint8List
      final Uint8List pdfBytes = await pdf.save();

      // Convert Uint8List to Blob
      final pdfBlob = html.Blob([pdfBytes]);

      // Convert Blob to Object URL
      final pdfUrl = uh.Url.createObjectUrlFromBlob(pdfBlob);

      // Create an anchor element
      final anchorElement = html.AnchorElement(href: pdfUrl)
        ..setAttribute("download", "draft_detail.pdf")
        ..text = "Download PDF";

      // Trigger a click event to start the download
      anchorElement.click();

      // Revoke the Object URL to release memory
      uh.Url.revokeObjectUrl(pdfUrl);
    } catch (e) {
      print('Error downloading PDF: $e');
      // Handle error if any
    }
  }

  void showDetailDialog(Map<String, dynamic> draftDetail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width *
                0.8, // Adjust the width as needed
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '注文内容詳細',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 22, 59, 224)),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            // Generate PDF and download
                            await _generateAndDownloadPDF(context, draftDetail);
                          },
                          icon: Icon(Icons.download),
                          label: Text(
                            'PDFダウンロード',
                            style: TextStyle(fontSize: 12.0),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .transparent, // Set background color to transparent
                            shadowColor: Colors.transparent, // Remove shadow
                            elevation: 0, // Remove elevation
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '発注者    ',
                            style: TextStyle(
                              fontFamily: 'Hiragino Sans',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            '${draftDetail['user']['name']}',
                            style: TextStyle(
                              fontFamily: 'Hiragino Sans',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors
                                  .grey[400], // Change to your desired color
                              decorationThickness:
                                  2.0, // Change to your desired thickness
                              decorationStyle: TextDecorationStyle.solid, // E
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'クライアント    ',
                            style: TextStyle(
                              fontFamily: 'Hiragino Sans',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            '${draftDetail['customer']['clientName']}',
                            style: TextStyle(
                              fontFamily: 'Hiragino Sans',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w300,

                              decoration: TextDecoration.underline,
                              decorationColor: Colors
                                  .grey[400], // Change to your desired color

                              decorationThickness:
                                  2.0, // Change to your desired thickness
                              decorationStyle: TextDecorationStyle
                                  .solid, // Ensure the decoration is solid
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '下書き合計金額  ',
                              style: TextStyle(
                                fontFamily: 'Hiragino Sans',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            TextSpan(
                              text: '  ¥  ${calculateTotalPrice(draftDetail)}',
                              style: TextStyle(
                                fontFamily: 'Hiragino Sans',
                                fontSize: 20.0, // Increase the font size
                                fontWeight:
                                    FontWeight.bold, // Apply bold font weight
                                // Add any other styles you want
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  width: 900,
                  child: Table(
                    border: TableBorder.all(
                        color: Color.fromARGB(
                            255, 224, 224, 226)), // Add borders to the table
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: Center(
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Center(child: Text('得意先発注No')),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: Center(
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Center(child: Text('得意先コード')),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: Center(
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Center(child: Text('配達先')),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: Center(
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Center(child: Text('出荷指定日')),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: Center(
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Center(child: Text('電話番号')),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: Center(
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Center(child: Text('注文日時')),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Add more TableRow as needed

                      TableRow(
                        children: [
                          TableCell(
                            child: Center(
                              child: SizedBox(
                                height: 40, // Adjust the height as needed
                                child: Center(
                                    child: Text(
                                        '${draftDetail['customer']['orderNumber']}')),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: SizedBox(
                                height: 40, // Adjust the height as needed
                                child: Center(
                                    child: Text(
                                        '${draftDetail['customer']['originalClientId']}')),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: SizedBox(
                                height: 40, // Adjust the height as needed
                                child: Center(
                                    child: Text(
                                        '${draftDetail['customer']['deliveryMethod']}')),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: SizedBox(
                                height: 40, // Adjust the height as needed
                                child: Center(
                                    child: Text(
                                  '${draftDetail['customer']['shippingDate']}' !=
                                          null
                                      ? DateFormat('yyyy/MM/dd').format(
                                          DateTime.parse(draftDetail['customer']
                                              ['shippingDate']))
                                      : '', // Format the shipping date if it exists, otherwise use an empty string
                                )),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: SizedBox(
                                height: 40, // Adjust the height as needed
                                child: Center(
                                    child: Text(
                                        '${draftDetail['customer']['clientPhone']}')),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: SizedBox(
                                height: 40, // Adjust the height as needed
                                child: Center(
                                  child: (Text(DateFormat('yyyy/MM/dd').format(
                                      DateTime.parse(
                                          draftDetail['created_at'] ?? '')))),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      // Add more TableRow as needed
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  width: 600,
                  child: Table(
                    border: TableBorder.all(
                        color: Color.fromARGB(
                            255, 224, 224, 226)), // Add borders to the table
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: Center(
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Center(child: Text('お届け先')),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: Center(
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Center(child: Text('')),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Add more TableRow as needed

                      TableRow(
                        children: [
                          TableCell(
                            child: Center(
                              child: SizedBox(
                                height: 40, // Adjust the height as needed
                                child: Center(
                                    child: Text(
                                        '〒  ${draftDetail['customer']['clientPhone']}')),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: SizedBox(
                                height: 40, // Adjust the height as needed
                                child: Center(
                                    child: Text(
                                        '${draftDetail['customer']['clientAddress']}')),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Add more TableRow as needed
                    ],
                  ),
                ),
                Container(
                  width: 600,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromARGB(255, 224, 224, 226),
                          ),
                        ),
                      ),
                      child: Text('備考   ${draftDetail['customer']['remark']}'),
                    ),
                  ),
                ),
                Container(
                  width: 600,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Color.fromARGB(255, 224, 224, 226)),
                        ),
                      ),
                      child:
                          Text('コメント   ${draftDetail['customer']['comment']}'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width * 0.8,
                  // Set the background color here
                  child: Table(
                    border: TableBorder.all(
                        color: Color.fromARGB(
                            255, 224, 224, 226)), // Add borders to the tabler
                    children: [
                      // Table header
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: Center(
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Center(child: Text('JANコード')),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: Center(
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Center(child: Text('型番')),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: Center(
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Center(child: Text('品名')),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: Center(
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Center(child: Text('数量')),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: Center(
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Center(child: Text('価格')),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: Center(
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Center(child: Text('金額')),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Table rows
                      for (var product in draftDetail['products'])
                        TableRow(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey), // Add borders to the row
                          ),
                          children: [
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(product['productJan'] ?? ''),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(product['productCode'] ?? ''),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(product['productName'] ?? ''),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      product['quantity']?.toString() ?? ''),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    product['productUnitPrice']?.toString() ??
                                        '',
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    ((product['quantity'] ?? 0) *
                                            (product['productUnitPrice'] ?? 0))
                                        .toString(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onFilterApplied(List<Map<String, dynamic>> filteredData) {
    setState(() {
      _filteredData = filteredData;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter data based on search text and filter criteria
    if (_searchText.isNotEmpty) {
      _filteredData = widget.sampleData.where((data) {
        // Check if the name, created_at, or shippingDate contains the search text
        return (data['customer']['clientName']?.toLowerCase() ?? '')
                .contains(_searchText.toLowerCase()) ||
            ((data['created_at'] ?? '')
                .toLowerCase()
                .contains(_searchText.toLowerCase())) ||
            ((data['customer']['shippingDate'] ?? '')
                .toLowerCase()
                .contains(_searchText.toLowerCase())) ||
            ((data['user']['name'] ?? '')
                .toLowerCase()
                .contains(_searchText.toLowerCase()));
      }).toList();
    } else {
      _filteredData = widget.sampleData;
    }

    int totalItems = _filteredData.length; // Use _filteredData.length
    int itemsPerPage = _rowsPerPage;
    int totalPages = (totalItems / itemsPerPage).ceil();

    // Determine the range of items to display on the current page
    int startIndex = (_currentPage - 1) * _rowsPerPage;
    int endIndex = min(_upperLimit, totalItems);

    // Get the items to display on the current page
    List<Map<String, dynamic>> currentPageItems =
        _filteredData.sublist(startIndex, endIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 50.0, left: 16, right: 16),
          child: Text(
            '注文一覧',
            style: TextStyle(
              fontFamily: 'Noto Sans JP',
              fontSize: 26.0,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchInput = value;
                _searchText = value;
                _filteredData = _filterData();
              });
            },
            decoration: InputDecoration(
              hintText: '名前などを入力',
              prefixIcon: Icon(Icons.person_search),
              suffixIcon: IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  _showFilterDialog();
                },
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10.0, right: 16, left: 16),
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1-$_upperLimit件目を表示'),
              SizedBox(width: 16),
              Row(
                children: [
                  Text('1ページあたりの表示件数'),
                  SizedBox(width: 8), // Adjust the width as needed
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey), // Add border decoration
                      borderRadius: BorderRadius.circular(
                          4.0), // Add border radius if needed
                    ),
                    child: SizedBox(
                      width: 80,
                      height: 30, // Adjust the width and height as needed
                      child: Center(
                        child: DropdownButton<int>(
                          value: _rowsPerPage,
                          onChanged: (value) {
                            changeRowsPerPage(value!);
                          },
                          underline: SizedBox(), // Remove the underline
                          icon: Icon(Icons.arrow_drop_down), // Set custom icon
                          focusColor: Colors.transparent, // Remove active color

                          items:
                              [10, 15, 20].map<DropdownMenuItem<int>>((value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text('$value'),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: DataTable(
              columns: [
                DataColumn(label: Text('クライアント')),
                DataColumn(label: Text('ストア名')),
                DataColumn(label: Text('区分')),
                DataColumn(label: Text('注文者')),
                DataColumn(label: Text('注文日時')),
                DataColumn(label: Text('希望納品日')),
                DataColumn(label: Text('アイテム数')),
                DataColumn(label: Text('合計金額')),
                DataColumn(label: Text('')),
              ],
              rows: _filteredData != null
                  ? _filteredData
                      .sublist((_currentPage - 1) * _rowsPerPage,
                          min(_upperLimit, totalItems)) // Use min function
                      .map<DataRow>((data) {
                      return DataRow(cells: [
                        DataCell(Text(data['customer']['clientName'] ?? '')),
                        DataCell(Text(data['customer']['clientBranch'] ?? '')),
                        DataCell(Text('')),
                        DataCell(Text(data['user']['name'] ?? '')),
                        DataCell(Text(DateFormat('yyyy/MM/dd')
                            .format(DateTime.parse(data['created_at'] ?? '')))),
                        DataCell(Text(
                          data['customer']['shippingDate'] != null
                              ? DateFormat('yyyy/MM/dd').format(DateTime.parse(
                                  data['customer']['shippingDate']))
                              : '', // Format the shipping date if it exists, otherwise use an empty string
                        )),
                        DataCell(
                            Text(data['products'].length.toString() ?? '')),
                        DataCell(Text(calculateTotalPrice(data))),
                        DataCell(
                          Container(
                            width: 104,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
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
                              onPressed: () {
                                showDetailDialog(
                                    data); // Handle view detail button press
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ),
                              child: Text(
                                '詳細',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]);
                    }).toList()
                  : [],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (_currentPage > 1) {
                    navigateToPage(_currentPage - 1);
                  }
                },
                child: Row(
                  children: [
                    Text('最初へ'),
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: () {
                        if (_currentPage > 1) {
                          navigateToPage(_currentPage - 1);
                        }
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(width: 16), // Add spacing between the buttons
              ...List.generate(
                totalPages,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      navigateToPage(index + 1);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: index + 1 == _currentPage
                              ? Color.fromARGB(255, 44, 22, 243)
                              : Colors.transparent,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: index + 1 == _currentPage
                              ? Color.fromARGB(255, 44, 22, 243)
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  if (_currentPage < totalPages) {
                    navigateToPage(_currentPage + 1);
                  }
                },
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: () {
                        if (_currentPage < totalPages) {
                          navigateToPage(_currentPage + 1);
                        }
                      },
                    ),
                    Text('最後へ'),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }
}
