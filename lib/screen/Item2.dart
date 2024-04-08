import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:raymay/api/token_manager.dart';

class Item2 extends StatefulWidget {
  final List<Map<String, dynamic>> sampleData;

  Item2({required this.sampleData});

  @override
  _Item2State createState() => _Item2State();
}

class _Item2State extends State<Item2> {
  int _rowsPerPage = 10; // Number of rows per page
  int _currentPage = 1; // Current page number
  int _upperLimit = 10; // Default value for the upper limit
  String _searchText = '';
  late List<Map<String, dynamic>> _filteredData;
  List<Map<String, dynamic>> sampleData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    _filteredData = widget.sampleData;
  }

  String calculateTotalPrice(Map<String, dynamic> data) {
    double totalPrice = 0;
    List<dynamic> products = data['products'];

    for (var product in products) {
      int quantity = product['quantity'] ?? 0;
      double unitPrice = product['productUnitPrice'] ?? 0.0;
      totalPrice += quantity * unitPrice;
    }

    // Format the total price with commas
    NumberFormat formatter = NumberFormat("#,##0.00", "en_US");
    return formatter.format(totalPrice);
  }

  Future<void> fetchData() async {
    final authToken = await TokenManager.getAccessToken();
    final Uri uri = Uri.parse(
        'https://qos.reimei-fujii.developers.engineerforce.io/api/v1/user/admin-drafts/');
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

  void navigateToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void changeRowsPerPage(int value) {
    setState(() {
      _rowsPerPage = value;
      _upperLimit = _currentPage * _rowsPerPage;
    });
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
                        '下書き内容詳細',
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
                          onPressed: () {
                            // Handle download PDF action
                          },
                          icon: Icon(Icons.download),
                          label: Text(
                            'PDFダウンロード',
                            style: TextStyle(fontSize: 12.0),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors
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
                      Text(
                        '下書き作成者    ${draftDetail['user']['name']}',
                        style: TextStyle(
                          fontFamily: 'Hiragino Sans',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '下書き保存日    ${draftDetail['created_at']}',
                        style: TextStyle(
                          fontFamily: 'Hiragino Sans',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'クライアント    ${draftDetail['customer']['clientName']}',
                        style: TextStyle(
                          fontFamily: 'Hiragino Sans',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w300,
                        ),
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
                  color: Colors.grey[200], // Set the background color here
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('得意先発注No')),
                      DataColumn(label: Text('得意先コード')),
                      DataColumn(label: Text('配達先')),
                      DataColumn(label: Text('出荷指定日')),
                      DataColumn(label: Text('電話番号')),
                      DataColumn(label: Text('注文日時')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(
                            Text('${draftDetail['customer']['orderNumber']}')),
                        DataCell(Text(
                            '${draftDetail['customer']['originalClientId']}')),
                        DataCell(Text(
                            '${draftDetail['customer']['deliveryMethod']}')),
                        DataCell(
                            Text('${draftDetail['customer']['shippingDate']}')),
                        DataCell(
                            Text('${draftDetail['customer']['clientPhone']}')),
                        DataCell(Text('${draftDetail['created_at']}')),
                      ]),
                      // Add more DataRow as needed
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.grey[200], // Set the background color here
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('得意先発注No')),
                      DataColumn(label: Text('')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text(
                            '〒  ${draftDetail['customer']['clientPhone']}')),
                        DataCell(Text(
                            '${draftDetail['customer']['clientAddress']}')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('備考')),
                        DataCell(Text('${draftDetail['customer']['remark']}')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('コメント')),
                        DataCell(Text('${draftDetail['customer']['comment']}')),
                      ]),
                      // Add more DataRow as needed
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.grey[200], // Set the background color here
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('JANコード')),
                      DataColumn(label: Text('型番')),
                      DataColumn(label: Text('品名')),
                      DataColumn(label: Text('数量')),
                      DataColumn(label: Text('価格')),
                      DataColumn(label: Text('金額')),
                    ],
                    rows: (draftDetail['products'] as List<dynamic>)
                        .map<DataRow>((product) {
                      // Calculate single total price
                      double singleTotalPrice = (product['quantity'] ?? 0) *
                          (product['productUnitPrice'] ?? 0);

                      // Map each product to a DataRow
                      return DataRow(cells: [
                        DataCell(Text(product['productJan'] ?? '')),
                        DataCell(Text(product['productCode'] ?? '')),
                        DataCell(Text(product['productName'] ?? '')),
                        DataCell(Text(product['quantity']?.toString() ?? '')),
                        DataCell(Text(
                            product['productUnitPrice']?.toString() ?? '')),
                        DataCell(Text(singleTotalPrice.toString())),
                      ]);
                    }).toList(),
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

  @override
  Widget build(BuildContext context) {
    print('Sample Data Length: ${sampleData.length}');
    print('Current Page: $_currentPage');
    print('Rows Per Page: $_rowsPerPage');
    if (_searchText.isNotEmpty) {
      _filteredData = sampleData.where((data) {
        return data['customer']['clientName']
                .toLowerCase()
                .contains(_searchText) || // Use _searchText directly
            (data['created_at'] != null &&
                data['created_at'].toLowerCase().contains(_searchText)) ||
            (data['customer']['shippingDate'] != null &&
                data['customer']['shippingDate']
                    .toLowerCase()
                    .contains(_searchText)) ||
            (data['user']['name'] != null &&
                data['user']['name'].toLowerCase().contains(_searchText));
      }).toList();
    } else {
      _filteredData = sampleData;
    }

    int totalItems = sampleData.length;
    int itemsPerPage = _rowsPerPage;
    int totalPages = (totalItems / itemsPerPage).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 50.0, left: 16, right: 16),
          child: Text(
            '下書き一覧',
            style: TextStyle(
              fontFamily: 'Noto Sans JP',
              fontSize: 26.0,
              fontWeight: FontWeight.w700,
              height: 1.5, // Adjust line height using height property
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10.0, right: 16, left: 16),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchText =
                    value.toLowerCase(); // Convert search text to lowercase
              });
            },
            decoration: InputDecoration(
              hintText: '名前などを入力',
              prefixIcon: Icon(Icons.person_search),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10.0, right: 16, left: 16),
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1-$_upperLimit件目を表示'), // Text before dropdown button
              SizedBox(
                  width:
                      16), // Add some space between the text and dropdown button
              DropdownButton<int>(
                value: _rowsPerPage,
                onChanged: (value) {
                  setState(() {
                    _rowsPerPage = value!;
                    // Update rows per page logic
                    // Update the upper limit based on the selected value
                    _upperLimit = value;
                  });
                },
                items: [10, 15, 20].map<DropdownMenuItem<int>>((value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value'),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        Expanded(
          // Wrap with Expanded
          child: Container(
            // Wrap with Container
            padding: const EdgeInsets.only(top: 10.0, right: 16, left: 16),
            child: SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('クライアント')),
                  DataColumn(label: Text('アイテム数')),
                  DataColumn(label: Text('合計金額')),
                  DataColumn(label: Text('下書き作成者')),
                  DataColumn(label: Text('下書き保存日')),
                  DataColumn(label: Text('希望納品日')),
                  DataColumn(label: Text('')),
                ],
                // Inside the DataTable rows section
                rows: _filteredData != null && _filteredData.isNotEmpty
                    ? _filteredData
                        .sublist(
                            (_currentPage - 1) * _rowsPerPage,
                            min((_currentPage * _rowsPerPage),
                                _filteredData.length))
                        .map<DataRow>((data) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Container(
                                width: 80,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 40, 41, 131),
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Text(
                                    'FAX依頼',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 40, 41, 131),
                                      fontFamily: 'Hiragino Sans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(data['customer'] != null
                                ? data['customer']['clientName'] ?? ''
                                : '')),
                            DataCell(Text(data['products'] != null
                                ? data['products'].length.toString() ?? ''
                                : '')),
                            DataCell(
                              Container(
                                child: Text(
                                  calculateTotalPrice(data),
                                ),
                              ),
                            ),
                            DataCell(Text(data['user'] != null
                                ? data['user']['name'] ?? ''
                                : '')),
                            DataCell(Text(DateFormat('yyyy-MM-dd').format(
                                DateTime.parse(data['created_at'] ?? '')))),
                            DataCell(Text(data['customer'] != null
                                ? data['customer']['shippingDate'] ?? ''
                                : '')),
                            DataCell(
                              Container(
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
                                        data); // Pass the draft detail to the function
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
                          ],
                        );
                      }).toList()
                    : [],
              ),
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
      ],
    );
  }
}
