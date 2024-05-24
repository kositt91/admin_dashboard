// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:raymay/api/token_manager.dart';
// import 'package:raymay/screen/filter_widget2.dart';
// import 'package:raymay/screen/filter_widget.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart'; // Import open_file package
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:open_file/open_file.dart';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'dart:html' as html;
// import 'package:universal_html/html.dart' as uh;
// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:http/http.dart' as http;
// import 'package:raymay/api/token_manager.dart';
// import 'package:intl/intl.dart';
// import 'package:raymay/screen/filter_widget.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart'; // Import open_file package
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:open_file/open_file.dart';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'dart:html' as html;
// import 'package:universal_html/html.dart' as uh;

// class Item2 extends StatefulWidget {
//   final List<Map<String, dynamic>> sampleData;

//   Item2({required this.sampleData});

//   @override
//   _Item2State createState() => _Item2State();
// }

// class _Item2State extends State<Item2> {
//   String clientNameFilter = '';
//   String startDateFilter = '';
//   String endDateFilter = '';
//   late TextEditingController _searchController;
//   int _rowsPerPage = 10; // Number of rows per page
//   int _currentPage = 1; // Current page number
//   int _upperLimit = 10; // Default value for the upper limit
//   String _searchText = '';
//   late List<Map<String, dynamic>> _filteredData;
//   List<Map<String, dynamic>> sampleData = [];
//   pw.Font? _notoSanFont;

//   @override
//   void initState() {
//     super.initState();
//     _searchController = TextEditingController();
//     fetchData();
//     loadFont();
//     _filteredData = widget.sampleData;
//   }

//   @override
//   void dispose() {
//     _searchController
//         .dispose(); // Dispose the controller when it's no longer needed
//     super.dispose();
//   }

//   String calculateTotalPrice(Map<String, dynamic> data) {
//     double totalPrice = 0;
//     List<dynamic> products = data['products'];

//     for (var product in products) {
//       int quantity = product['quantity'] ?? 0;
//       double unitPrice = product['productUnitPrice'] ?? 0.0;
//       totalPrice += quantity * unitPrice;
//     }

//     // Format the total price with commas
//     NumberFormat formatter = NumberFormat("#,##0", "en_US");
//     return formatter.format(totalPrice);
//   }

//   Future<void> fetchData() async {
//     final authToken = await TokenManager.getAccessToken();
//     final Uri uri = Uri.parse(
//         'https://qos.reimei-fujii.developers.engineerforce.io/api/v1/user/admin-drafts/');
//     final Map<String, String> headers = {
//       'Authorization': 'Bearer $authToken',
//     };

//     try {
//       final response = await http.get(uri, headers: headers);

//       if (response.statusCode == 200) {
//         List<dynamic> data = jsonDecode(response.body);
//         if (data.isNotEmpty && data[0] is List) {
//           // Check if data is not empty and is a list
//           setState(() {
//             sampleData =
//                 data[0].cast<Map<String, dynamic>>(); // Access the inner list
//           });
//         } else {
//           throw Exception('Data is not in the expected format');
//         }
//       } else {
//         print('Failed to load data. Status code: ${response.statusCode}');
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//       throw Exception('Error fetching data');
//     }
//   }

//   void navigateToPage(int page) {
//     setState(() {
//       _currentPage = page;
//     });
//   }

//   void changeRowsPerPage(int value) {
//     setState(() {
//       _rowsPerPage = value;
//       _upperLimit = _currentPage * _rowsPerPage;
//     });
//   }

//   Future<void> loadFont() async {
//     ByteData fontData = await rootBundle.load("/fonts/notosan.ttf");
//     setState(() {
//       _notoSanFont = pw.Font.ttf(fontData);
//     });
//   }

//   // Create a PDF document
//   Future<void> _generateAndDownloadPDF(
//       BuildContext context, Map<String, dynamic> draftDetail) async {
//     try {
//       // Create a PDF document
//       final pdf = pw.Document();

//       // Add content to the PDF document
//       pdf.addPage(
//         pw.Page(
//           build: (pw.Context context) {
//             return pw.Container(
//               // Adjust the width as needed
//               child: pw.Column(
//                 mainAxisSize: pw.MainAxisSize.min,
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Padding(
//                         padding: const pw.EdgeInsets.all(0.0),
//                         child: pw.Text(
//                           '注文内容詳細',
//                           style: pw.TextStyle(
//                             fontSize: 16.0,
//                             fontWeight: pw.FontWeight.bold,
//                             fontFallback: [
//                               _notoSanFont ??
//                                   pw.Font
//                                       .helvetica(), // Use Helvetica as a fallback font
//                             ], // Use the loaded font here
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   pw.Padding(
//                     padding: const pw.EdgeInsets.symmetric(vertical: 10.0),
//                     child: pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Row(
//                           children: [
//                             pw.Text(
//                               '発注者    ',
//                               style: pw.TextStyle(
//                                 fontSize: 12.0,
//                                 fontFallback: [
//                                   _notoSanFont ??
//                                       pw.Font
//                                           .helvetica(), // Use Helvetica as a fallback font
//                                 ],
//                               ),
//                             ),
//                             pw.Text(
//                               '${draftDetail['user']['name'] ?? ''}',
//                               style: pw.TextStyle(
//                                 fontSize: 12.0,

//                                 fontFallback: [
//                                   _notoSanFont ??
//                                       pw.Font
//                                           .helvetica(), // Use Helvetica as a fallback font
//                                 ],
//                                 decoration: pw.TextDecoration.underline,

//                                 decorationThickness:
//                                     2.0, // Change to your desired thickness
//                                 decorationStyle:
//                                     pw.TextDecorationStyle.solid, // E
//                               ),
//                             ),
//                           ],
//                         ),
//                         pw.SizedBox(
//                           height: 10,
//                         ),
//                         pw.Row(
//                           children: [
//                             pw.Text(
//                               'クライアント    ',
//                               style: pw.TextStyle(
//                                 fontSize: 12.0,
//                                 fontWeight: pw.FontWeight.bold,
//                                 fontFallback: [
//                                   _notoSanFont ??
//                                       pw.Font
//                                           .helvetica(), // Use Helvetica as a fallback font
//                                 ],
//                               ),
//                             ),
//                             pw.Text(
//                               '${draftDetail['customer']['clientName'] ?? ''}',
//                               style: pw.TextStyle(
//                                 fontSize: 12.0,
//                                 fontWeight: pw.FontWeight.bold,

//                                 decoration: pw.TextDecoration.underline,
//                                 // Change to your desired color

//                                 decorationThickness:
//                                     2.0, // Change to your desired thickness
//                                 decorationStyle: pw.TextDecorationStyle
//                                     .solid, // Ensure the decoration is solid
//                               ),
//                             ),
//                           ],
//                         ),
//                         pw.SizedBox(
//                           height: 10,
//                         ),
//                         pw.RichText(
//                           text: pw.TextSpan(
//                             children: [
//                               pw.TextSpan(
//                                 text: '下書き合計金額  ',
//                                 style: pw.TextStyle(
//                                   fontSize: 12.0,
//                                   fontWeight: pw.FontWeight.bold,
//                                   fontFallback: [
//                                     _notoSanFont ??
//                                         pw.Font
//                                             .helvetica(), // Use Helvetica as a fallback font
//                                   ],
//                                 ),
//                               ),
//                               pw.TextSpan(
//                                 text:
//                                     '  ¥  ${calculateTotalPrice(draftDetail)}',
//                                 style: pw.TextStyle(
//                                   fontSize: 12.0, // Increase the font size
//                                   fontWeight: pw.FontWeight
//                                       .bold, // Apply bold font weight
//                                   // Add any other styles you want
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   pw.SizedBox(
//                     height: 20,
//                   ),
//                   pw.Container(
//                     width: 900,
//                     child: pw.Table(
//                       border: pw.TableBorder.all(
//                         color: PdfColor.fromHex(
//                             '#CCCCCC'), // Set border color to black
//                         width: 1, // Set border width
//                         style: pw.BorderStyle.solid, // Set border style
//                       ), // Add borders to the table
//                       children: [
//                         pw.TableRow(
//                           children: [
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               color: PdfColor.fromHex('#CCCCCC'),
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                     child: pw.Text('得意先発注No',
//                                         style: pw.TextStyle(
//                                           fontFallback: [
//                                             _notoSanFont ?? pw.Font.helvetica(),
//                                             // Use Helvetica as a fallback font
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               color: PdfColor.fromHex('#CCCCCC'),
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                     child: pw.Text('得意先コード',
//                                         style: pw.TextStyle(
//                                           fontFallback: [
//                                             _notoSanFont ??
//                                                 pw.Font
//                                                     .helvetica(), // Use Helvetica as a fallback font
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               color: PdfColor.fromHex('#CCCCCC'),
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                     child: pw.Text('配達先',
//                                         style: pw.TextStyle(
//                                           fontFallback: [
//                                             _notoSanFont ??
//                                                 pw.Font
//                                                     .helvetica(), // Use Helvetica as a fallback font
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               color: PdfColor.fromHex('#CCCCCC'),
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                     child: pw.Text('出荷指定日',
//                                         style: pw.TextStyle(
//                                           fontFallback: [
//                                             _notoSanFont ??
//                                                 pw.Font
//                                                     .helvetica(), // Use Helvetica as a fallback font
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               color: PdfColor.fromHex('#CCCCCC'),
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                     child: pw.Text('電話番号',
//                                         style: pw.TextStyle(
//                                           fontFallback: [
//                                             _notoSanFont ??
//                                                 pw.Font
//                                                     .helvetica(), // Use Helvetica as a fallback font
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               color: PdfColor.fromHex('#CCCCCC'),
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                     child: pw.Text('注文日時',
//                                         style: pw.TextStyle(
//                                           fontFallback: [
//                                             _notoSanFont ??
//                                                 pw.Font
//                                                     .helvetica(), // Use Helvetica as a fallback font
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                           ],
//                         ),

//                         // Add more TableRow as needed

//                         pw.TableRow(
//                           children: [
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                     child: pw.Text(
//                                         '${draftDetail['customer']['orderNumber'] ?? ''}',
//                                         style: pw.TextStyle(
//                                           fontFallback: [
//                                             _notoSanFont ??
//                                                 pw.Font
//                                                     .helvetica(), // Use Helvetica as a fallback font
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                     child: pw.Text(
//                                         '${draftDetail['customer']['originalClientId'] ?? ''}',
//                                         style: pw.TextStyle(
//                                           fontFallback: [
//                                             _notoSanFont ??
//                                                 pw.Font
//                                                     .helvetica(), // Use Helvetica as a fallback font
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                     child: pw.Text(
//                                         '${draftDetail['customer']['deliveryMethod'] ?? ''}',
//                                         style: pw.TextStyle(
//                                           fontFallback: [
//                                             _notoSanFont ??
//                                                 pw.Font
//                                                     .helvetica(), // Use Helvetica as a fallback font
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                     child: pw.Text(
//                                   draftDetail['customer']['shippingDate'] !=
//                                           null
//                                       ? DateFormat('yyyy/MM/dd').format(
//                                           DateTime.parse(draftDetail['customer']
//                                               ['shippingDate']),
//                                         )
//                                       : '',
//                                   style: pw.TextStyle(
//                                     fontFallback: [
//                                       _notoSanFont ??
//                                           pw.Font
//                                               .helvetica(), // Use Helvetica as a fallback font
//                                     ],
//                                   ),
//                                 )),
//                               ),
//                             ),
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                     child: pw.Text(
//                                         '${draftDetail['customer']['clientPhone'] ?? ''}',
//                                         style: pw.TextStyle(
//                                           fontFallback: [
//                                             _notoSanFont ??
//                                                 pw.Font
//                                                     .helvetica(), // Use Helvetica as a fallback font
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                   child: pw.Text(
//                                       DateFormat('yyyy/MM/dd').format(
//                                           DateTime.parse(
//                                               draftDetail['created_at'] ?? '')),
//                                       style: pw.TextStyle(
//                                         fontFallback: [
//                                           _notoSanFont ??
//                                               pw.Font
//                                                   .helvetica(), // Use Helvetica as a fallback font
//                                         ],
//                                       )),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         // Add more TableRow as needed
//                       ],
//                     ),
//                   ),
//                   pw.SizedBox(
//                     height: 20,
//                   ),
//                   pw.Container(
//                     width: 400,
//                     child: pw.Table(
//                       border: pw.TableBorder.all(
//                         color: PdfColor.fromHex(
//                             '#CCCCCC'), // Set border color to black
//                         width: 1, // Set border width
//                         style: pw.BorderStyle.solid,
//                       ),
//                       children: [
//                         pw.TableRow(
//                           children: [
//                             pw.Container(
//                               // Background color for the cell
//                               color: PdfColor.fromHex('#CCCCCC'),
//                               alignment: pw.Alignment.center,
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                   child: pw.Text('お届け先',
//                                       style: pw.TextStyle(
//                                         fontFallback: [
//                                           _notoSanFont ??
//                                               pw.Font
//                                                   .helvetica(), // Use Helvetica as a fallback font
//                                         ],
//                                       )),
//                                 ),
//                               ),
//                             ),
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               color: PdfColor.fromHex('#CCCCCC'),
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                   child: pw.Text(''),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         // Add more TableRow as needed

//                         pw.TableRow(
//                           children: [
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                   child: pw.Text(
//                                     '〒  ${draftDetail['customer']['clientPhone'] ?? ''}',
//                                     style: pw.TextStyle(
//                                       fontFallback: [
//                                         _notoSanFont ?? pw.Font.helvetica(),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                   child: pw.Text(
//                                     '${draftDetail['customer']['clientAddress'] ?? ''}',
//                                     style: pw.TextStyle(
//                                       fontFallback: [
//                                         _notoSanFont ?? pw.Font.helvetica(),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         // Add more TableRow as needed
//                       ],
//                     ),
//                   ),
//                   pw.Container(
//                     width: 300,
//                     child: pw.Padding(
//                       padding: pw.EdgeInsets.only(top: 10),
//                       child: pw.Container(
//                         decoration: pw.BoxDecoration(
//                           border: pw.Border(
//                             bottom: pw.BorderSide(
//                               color: PdfColor.fromHex(
//                                   '#CCCCCC'), // Set border color to black
//                               width: 1, // Set border width
//                               style: pw.BorderStyle.solid,
//                             ),
//                           ),
//                         ),
//                         child: pw.Text(
//                           '備考   ${draftDetail['customer']['remark'] ?? ''}',
//                           style: pw.TextStyle(
//                             fontFallback: [
//                               _notoSanFont ?? pw.Font.helvetica(),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   pw.Container(
//                     width: 300,
//                     child: pw.Padding(
//                       padding: pw.EdgeInsets.only(top: 10),
//                       child: pw.Container(
//                         decoration: pw.BoxDecoration(
//                           border: pw.Border(
//                               bottom: pw.BorderSide(
//                             color: PdfColor.fromHex(
//                                 '#CCCCCC'), // Set border color to black
//                             width: 1, // Set border width
//                             style: pw.BorderStyle.solid,
//                           )),
//                         ),
//                         child: pw.Text(
//                           'コメント   ${draftDetail['customer']['comment'] ?? ''}',
//                           style: pw.TextStyle(
//                             fontFallback: [
//                               _notoSanFont ?? pw.Font.helvetica(),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   pw.SizedBox(
//                     height: 10,
//                   ),
//                   pw.Container(
//                     width: 1000,

//                     // Set the background color here
//                     child: pw.Table(
//                       border: pw.TableBorder.all(
//                         color: PdfColor.fromHex(
//                             '#CCCCCC'), // Set border color to black
//                         width: 1, // Set border width
//                         style: pw.BorderStyle.solid,
//                       ), // Add borders to the tabler
//                       children: [
//                         // Table header
//                         pw.TableRow(
//                           children: [
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               color: PdfColor.fromHex('#CCCCCC'),
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                     child: pw.Text('JANコード',
//                                         style: pw.TextStyle(
//                                           fontFallback: [
//                                             _notoSanFont ??
//                                                 pw.Font
//                                                     .helvetica(), // Use Helvetica as a fallback font
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               color: PdfColor.fromHex('#CCCCCC'),
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                     child: pw.Text('型番',
//                                         style: pw.TextStyle(
//                                           fontFallback: [
//                                             _notoSanFont ??
//                                                 pw.Font
//                                                     .helvetica(), // Use Helvetica as a fallback font
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               color: PdfColor.fromHex('#CCCCCC'),
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                     child: pw.Text('品名',
//                                         style: pw.TextStyle(
//                                           fontFallback: [
//                                             _notoSanFont ??
//                                                 pw.Font
//                                                     .helvetica(), // Use Helvetica as a fallback font
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               color: PdfColor.fromHex('#CCCCCC'),
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                     child: pw.Text('数量',
//                                         style: pw.TextStyle(
//                                           fontFallback: [
//                                             _notoSanFont ??
//                                                 pw.Font
//                                                     .helvetica(), // Use Helvetica as a fallback font
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               color: PdfColor.fromHex('#CCCCCC'),
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                     child: pw.Text('価格',
//                                         style: pw.TextStyle(
//                                           fontFallback: [
//                                             _notoSanFont ??
//                                                 pw.Font
//                                                     .helvetica(), // Use Helvetica as a fallback font
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                             pw.Container(
//                               // Background color for the cell
//                               alignment: pw.Alignment.center,
//                               color: PdfColor.fromHex('#CCCCCC'),
//                               child: pw.SizedBox(
//                                 height: 25, // Adjust the height as needed
//                                 child: pw.Center(
//                                     child: pw.Text('金額',
//                                         style: pw.TextStyle(
//                                           fontFallback: [
//                                             _notoSanFont ??
//                                                 pw.Font
//                                                     .helvetica(), // Use Helvetica as a fallback font
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                           ],
//                         ),
// // Table rows
//                         for (var product in draftDetail['products'])
//                           pw.TableRow(
//                             decoration: pw.BoxDecoration(
//                                 // Add borders to the row
//                                 ),
//                             children: [
//                               pw.Container(
//                                 alignment: pw.Alignment.center,
//                                 child: pw.Padding(
//                                   padding: const pw.EdgeInsets.all(8.0),
//                                   child: pw.Text(product['productJan'] ?? ''),
//                                 ),
//                               ),
//                               pw.Container(
//                                 alignment: pw.Alignment.center,
//                                 child: pw.Padding(
//                                   padding: const pw.EdgeInsets.all(8.0),
//                                   child: pw.Text(product['productCode'] ?? ''),
//                                 ),
//                               ),
//                               pw.Container(
//                                 alignment: pw.Alignment.center,
//                                 child: pw.Padding(
//                                   padding: const pw.EdgeInsets.all(8.0),
//                                   child: pw.Text(product['productName'] ?? ''),
//                                 ),
//                               ),
//                               pw.Container(
//                                 alignment: pw.Alignment.center,
//                                 child: pw.Padding(
//                                   padding: const pw.EdgeInsets.all(8.0),
//                                   child: pw.Text(
//                                       product['quantity']?.toString() ?? ''),
//                                 ),
//                               ),
//                               pw.Container(
//                                 alignment: pw.Alignment.center,
//                                 child: pw.Padding(
//                                   padding: const pw.EdgeInsets.all(8.0),
//                                   child: pw.Text(
//                                       product['productUnitPrice']?.toString() ??
//                                           ''),
//                                 ),
//                               ),
//                               pw.Container(
//                                 alignment: pw.Alignment.center,
//                                 child: pw.Padding(
//                                   padding: const pw.EdgeInsets.all(8.0),
//                                   child: pw.Text(
//                                     ((product['quantity'] ?? 0) *
//                                             (product['productUnitPrice'] ?? 0))
//                                         .toString(),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                       ],
//                     ),
//                   ),
//                   pw.SizedBox(height: 16.0),
//                 ],
//               ),
//             );
//           },
//         ),
//       );

//       // Save the PDF document to a Uint8List
//       final Uint8List pdfBytes = await pdf.save();

//       // Convert Uint8List to Blob
//       final pdfBlob = html.Blob([pdfBytes]);

//       // Convert Blob to Object URL
//       final pdfUrl = uh.Url.createObjectUrlFromBlob(pdfBlob);

//       // Create an anchor element
//       final anchorElement = html.AnchorElement(href: pdfUrl)
//         ..setAttribute("download", "draft_detail.pdf")
//         ..text = "Download PDF";

//       // Trigger a click event to start the download
//       anchorElement.click();

//       // Revoke the Object URL to release memory
//       uh.Url.revokeObjectUrl(pdfUrl);
//     } catch (e) {
//       print('Error downloading PDF: $e');
//       // Handle error if any
//     }
//   }

//   void showDetailDialog(Map<String, dynamic> draftDetail) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           insetPadding: EdgeInsets.symmetric(horizontal: 16.0),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(4.0),
//           ),
//           child: Container(
//             color: Colors.white,
//             width: MediaQuery.of(context).size.width *
//                 0.8, // Adjust the width as needed
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Text(
//                         '下書き内容詳細',
//                         style: TextStyle(
//                           fontSize: 24.0,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(right: 16),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                               color: Color.fromARGB(255, 22, 59, 224)),
//                           borderRadius: BorderRadius.circular(40.0),
//                         ),
//                         child: ElevatedButton.icon(
//                           onPressed: () async {
//                             // Generate PDF and download
//                             await _generateAndDownloadPDF(context, draftDetail);
//                           },
//                           icon: Icon(Icons.download),
//                           label: Text(
//                             'PDFダウンロード',
//                             style: TextStyle(fontSize: 12.0),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors
//                                 .transparent, // Set background color to transparent
//                             shadowColor: Colors.transparent, // Remove shadow
//                             elevation: 0, // Remove elevation
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '下書き作成者    ${draftDetail['user']['name']}',
//                         style: TextStyle(
//                           fontFamily: 'Hiragino Sans',
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.w300,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         '下書き保存日    ${draftDetail['created_at']}',
//                         style: TextStyle(
//                           fontFamily: 'Hiragino Sans',
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.w300,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         'クライアント    ${draftDetail['customer']['clientName'] ?? 'N/A'}',
//                         style: TextStyle(
//                           fontFamily: 'Hiragino Sans',
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.w300,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: '下書き合計金額  ',
//                               style: TextStyle(
//                                 fontFamily: 'Hiragino Sans',
//                                 fontSize: 16.0,
//                                 fontWeight: FontWeight.w300,
//                               ),
//                             ),
//                             TextSpan(
//                               text: '  ¥  ${calculateTotalPrice(draftDetail)}',
//                               style: TextStyle(
//                                 fontFamily: 'Hiragino Sans',
//                                 fontSize: 20.0, // Increase the font size
//                                 fontWeight:
//                                     FontWeight.bold, // Apply bold font weight
//                                 // Add any other styles you want
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Container(
//                   padding: EdgeInsets.only(left: 20),
//                   width: 900,
//                   child: Table(
//                     border: TableBorder.all(
//                         color: Color.fromARGB(255, 224, 224, 226)),
//                     children: [
//                       TableRow(children: [
//                         TableCell(
//                           child: Container(
//                             color: Color(
//                                 0x23131314), // Background color for the cell
//                             child: Center(
//                               child: SizedBox(
//                                 height: 40, // Adjust the height as needed
//                                 child: Center(child: Text('得意先発注No')),
//                               ),
//                             ),
//                           ),
//                         ),
//                         TableCell(
//                           child: Container(
//                             color: Color(
//                                 0x23131314), // Background color for the cell
//                             child: Center(
//                               child: SizedBox(
//                                 height: 40, // Adjust the height as needed
//                                 child: Center(child: Text('得意先コード')),
//                               ),
//                             ),
//                           ),
//                         ),
//                         TableCell(
//                           child: Container(
//                             color: Color(
//                                 0x23131314), // Background color for the cell
//                             child: Center(
//                               child: SizedBox(
//                                 height: 40, // Adjust the height as needed
//                                 child: Center(child: Text('配達先')),
//                               ),
//                             ),
//                           ),
//                         ),
//                         TableCell(
//                           child: Container(
//                             color: Color(
//                                 0x23131314), // Background color for the cell
//                             child: Center(
//                               child: SizedBox(
//                                 height: 40, // Adjust the height as needed
//                                 child: Center(child: Text('出荷指定日')),
//                               ),
//                             ),
//                           ),
//                         ),
//                         TableCell(
//                           child: Container(
//                             color: Color(
//                                 0x23131314), // Background color for the cell
//                             child: Center(
//                               child: SizedBox(
//                                 height: 40, // Adjust the height as needed
//                                 child: Center(child: Text('電話番号')),
//                               ),
//                             ),
//                           ),
//                         ),
//                         TableCell(
//                           child: Container(
//                             color: Color(
//                                 0x23131314), // Background color for the cell
//                             child: Center(
//                               child: SizedBox(
//                                 height: 40, // Adjust the height as needed
//                                 child: Center(child: Text('注文日時')),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ]),
//                       TableRow(children: [
//                         TableCell(
//                             child: Center(
//                           child: SizedBox(
//                             height: 40,
//                             child: Center(
//                               child: Text(
//                                   '${draftDetail['customer']['orderNumber'] ?? 'N/A'}'),
//                             ),
//                           ),
//                         )),
//                         TableCell(
//                             child: Center(
//                           child: SizedBox(
//                             height: 40,
//                             child: Center(
//                               child: Text(
//                                   '${draftDetail['customer']['originalClientId'] ?? 'N/A'}'),
//                             ),
//                           ),
//                         )),
//                         TableCell(
//                             child: Center(
//                           child: SizedBox(
//                             height: 40,
//                             child: Center(
//                               child: Text(
//                                   '${draftDetail['customer']['deliveryMethod'] ?? 'N/A'}'),
//                             ),
//                           ),
//                         )),
//                         TableCell(
//                             child: Center(
//                           child: SizedBox(
//                             height: 40,
//                             child: Center(
//                               child: Text(
//                                   '${draftDetail['customer']['shippingDate'] ?? 'N/A'}'),
//                             ),
//                           ),
//                         )),
//                         TableCell(
//                             child: Center(
//                           child: SizedBox(
//                             height: 40,
//                             child: Center(
//                               child: Text(
//                                   '${draftDetail['customer']['clientPhone'] ?? 'N/A'}'),
//                             ),
//                           ),
//                         )),
//                         TableCell(
//                             child: Center(
//                           child: SizedBox(
//                             height: 40,
//                             child: Center(
//                               child:
//                                   Text('${draftDetail['created_at'] ?? 'N/A'}'),
//                             ),
//                           ),
//                         ))
//                       ]),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                     padding: EdgeInsets.only(left: 20),
//                     width: 600,
//                     child: Table(
//                       border: TableBorder.all(
//                           color: const Color.fromARGB(255, 224, 224, 226)),
//                       children: [
//                         TableRow(
//                           children: [
//                             TableCell(
//                               child: Container(
//                                 color: Color(
//                                     0x23131314), // Background color for the cell
//                                 child: Center(
//                                   child: SizedBox(
//                                     height: 40, // Adjust the height as needed
//                                     child: Center(child: Text('得意先発注No')),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             TableCell(
//                               child: Container(
//                                 color: Color(
//                                     0x23131314), // Background color for the cell
//                                 child: Center(
//                                   child: SizedBox(
//                                     height: 40, // Adjust the height as needed
//                                     child: Center(child: Text('')),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         TableRow(
//                           children: [
//                             TableCell(
//                               child: Center(
//                                 child: SizedBox(
//                                   height: 40, // Adjust the height as needed
//                                   child: Center(
//                                       child: Text(
//                                           '〒  ${draftDetail['customer']['clientPhone'] ?? 'N/A'}')),
//                                 ),
//                               ),
//                             ),
//                             TableCell(
//                               child: Center(
//                                 child: SizedBox(
//                                   height: 40, // Adjust the height as needed
//                                   child: Center(
//                                       child: Text(
//                                           '${draftDetail['customer']['clientAddress'] ?? 'N/A'}')),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     )),
//                 Container(
//                   width: 600,
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 20, top: 10),
//                     child: Container(
//                       decoration: const BoxDecoration(
//                         border: Border(
//                           bottom: BorderSide(
//                             color: Color.fromARGB(255, 224, 224, 226),
//                           ),
//                         ),
//                       ),
//                       child: Text(
//                           '備考   ${draftDetail['customer']['remark'] ?? 'N/A'}'),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: 600,
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 20, top: 10),
//                     child: Container(
//                       decoration: const BoxDecoration(
//                         border: Border(
//                           bottom: BorderSide(
//                               color: Color.fromARGB(255, 224, 224, 226)),
//                         ),
//                       ),
//                       child: Text(
//                           'コメント   ${draftDetail['customer']['comment'] ?? 'N/A'}'),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(20),
//                   width: MediaQuery.of(context).size.width * 0.8,
//                   // Set the background color here
//                   child: Table(
//                     border: TableBorder.all(
//                         color: Color.fromARGB(
//                             255, 224, 224, 226)), // Add borders to the tabler
//                     children: [
//                       // Table header
//                       TableRow(
//                         children: [
//                           TableCell(
//                             child: Container(
//                               color: Color(
//                                   0x23131314), // Background color for the cell
//                               child: const Center(
//                                 child: SizedBox(
//                                   height: 40, // Adjust the height as needed
//                                   child: Center(child: Text('JANコード')),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           TableCell(
//                             child: Container(
//                               color: Color(
//                                   0x23131314), // Background color for the cell
//                               child: const Center(
//                                 child: SizedBox(
//                                   height: 40, // Adjust the height as needed
//                                   child: Center(child: Text('型番')),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           TableCell(
//                             child: Container(
//                               color: Color(
//                                   0x23131314), // Background color for the cell
//                               child: const Center(
//                                 child: SizedBox(
//                                   height: 40, // Adjust the height as needed
//                                   child: Center(child: Text('品名')),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           TableCell(
//                             child: Container(
//                               color: Color(
//                                   0x23131314), // Background color for the cell
//                               child: const Center(
//                                 child: SizedBox(
//                                   height: 40, // Adjust the height as needed
//                                   child: Center(child: Text('数量')),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           TableCell(
//                             child: Container(
//                               color: Color(
//                                   0x23131314), // Background color for the cell
//                               child: const Center(
//                                 child: SizedBox(
//                                   height: 40, // Adjust the height as needed
//                                   child: Center(child: Text('価格')),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           TableCell(
//                             child: Container(
//                               color: Color(
//                                   0x23131314), // Background color for the cell
//                               child: const Center(
//                                 child: SizedBox(
//                                   height: 40, // Adjust the height as needed
//                                   child: Center(child: Text('金額')),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       // Table rows
//                       for (var product in draftDetail['products'] ?? 'N/A')
//                         TableRow(
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                                 color: Colors.grey), // Add borders to the row
//                           ),
//                           children: [
//                             TableCell(
//                               child: Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(product['productJan'] ?? 'N/A'),
//                                 ),
//                               ),
//                             ),
//                             TableCell(
//                               child: Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(product['productCode'] ?? 'N/A'),
//                                 ),
//                               ),
//                             ),
//                             TableCell(
//                               child: Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(product['productName'] ?? 'N/A'),
//                                 ),
//                               ),
//                             ),
//                             TableCell(
//                               child: Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                       product['quantity']?.toString() ?? 'N/A'),
//                                 ),
//                               ),
//                             ),
//                             TableCell(
//                               child: Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                     product['productUnitPrice']?.toString() ??
//                                         'N/A',
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             TableCell(
//                               child: Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                     ((product['quantity'] ?? 0) *
//                                             (product['productUnitPrice'] ?? 0))
//                                         .toString(),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 16.0),
//                 Align(
//                   alignment: Alignment.center,
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text('Close'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     print('Sample Data Length: ${sampleData.length}');
//     print('Current Page: $_currentPage');
//     print('Rows Per Page: $_rowsPerPage');
//     if (_searchText.isNotEmpty) {
//       _filteredData = sampleData.where((data) {
//         // Apply filters
//         bool matchesClientName = data['customer'] != null &&
//             data['customer']['clientName'] != null &&
//             data['customer']['clientName']
//                 .toLowerCase()
//                 .contains(clientNameFilter.toLowerCase());
//         bool matchesStartDate = startDateFilter.isEmpty ||
//             (data['created_at'] != null &&
//                 data['created_at'] >= startDateFilter);
//         bool matchesEndDate = endDateFilter.isEmpty ||
//             (data['created_at'] != null && data['created_at'] <= endDateFilter);
//         return matchesClientName && matchesStartDate && matchesEndDate;
//       }).toList();
//     } else {
//       _filteredData = sampleData;
//     }

//     int totalItems = sampleData.length;
//     int itemsPerPage = _rowsPerPage;
//     int totalPages = (totalItems / itemsPerPage).ceil();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Container(
//           color: Color.fromARGB(255, 243, 243, 243),
//           padding: const EdgeInsets.only(top: 50.0, left: 16, right: 16),
//           child: Text(
//             '下書き一覧',
//             style: TextStyle(
//               fontFamily: 'Noto Sans JP',
//               fontSize: 26.0,
//               fontWeight: FontWeight.w700,
//               height: 1.5, // Adjust line height using height property
//             ),
//           ),
//         ),
//         Container(
//           color: Color.fromARGB(255, 243, 243, 243),
//           padding: const EdgeInsets.only(top: 10.0, right: 16, left: 16),
//           child: TextField(
//             controller: _searchController,
//             onChanged: (value) {
//               setState(() {
//                 _searchText =
//                     value.toLowerCase(); // Convert search text to lowercase
//               });
//             },
//             decoration: InputDecoration(
//               hintText: '名前などを入力',
//               prefixIcon: Icon(Icons.person_search),
//               suffixIcon: IconButton(
//                 icon: Icon(Icons.filter_list),
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return Stack(
//                         children: [
//                           Positioned(
//                               right: 0,
//                               top: 200,
//                               child: Dialog(
//                                 insetPadding:
//                                     EdgeInsets.symmetric(horizontal: 16.0),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(50.0),
//                                 ),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                     color: Colors.white,
//                                   ),
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.4,
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.all(0.0),
//                                         child: Text(
//                                           '',
//                                           style: TextStyle(
//                                             fontSize: 24.0,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ),
//                                       const Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 16.0),
//                                         child: Column(
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   'クライアント',
//                                                   style: TextStyle(
//                                                     fontSize: 16.0,
//                                                     fontWeight: FontWeight.w500,
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 8.0),
//                                                 Expanded(
//                                                   child: TextField(
//                                                     decoration:
//                                                         InputDecoration(),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   '発注者           ',
//                                                   style: TextStyle(
//                                                     fontSize: 16.0,
//                                                     fontWeight: FontWeight.w500,
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 8.0),
//                                                 Expanded(
//                                                   child: TextField(
//                                                     decoration:
//                                                         InputDecoration(),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   '注文日時       ',
//                                                   style: TextStyle(
//                                                     fontSize: 16.0,
//                                                     fontWeight: FontWeight.w500,
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 8.0),
//                                                 Expanded(
//                                                   child: TextField(
//                                                     decoration: InputDecoration(
//                                                       hintText: 'Start Date',
//                                                       suffixIcon: Icon(Icons
//                                                           .calendar_today), // Move calendar icon to the end
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   '   〜   ',
//                                                   style: TextStyle(
//                                                     fontSize: 23.0,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 8.0),
//                                                 Expanded(
//                                                   child: TextField(
//                                                     decoration: InputDecoration(
//                                                       hintText: 'End Date',
//                                                       suffixIcon: Icon(Icons
//                                                           .calendar_today), // Move calendar icon to the end
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   '希望納品日   ',
//                                                   style: TextStyle(
//                                                     fontSize: 16.0,
//                                                     fontWeight: FontWeight.w500,
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 8.0),
//                                                 Expanded(
//                                                   child: TextField(
//                                                     decoration: InputDecoration(
//                                                       hintText: 'Start Date',
//                                                       suffixIcon: Icon(Icons
//                                                           .calendar_today), // Move calendar icon to the end
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   '   〜   ',
//                                                   style: TextStyle(
//                                                     fontSize: 23.0,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 8.0),
//                                                 Expanded(
//                                                   child: TextField(
//                                                     decoration: InputDecoration(
//                                                       hintText: 'End Date',
//                                                       suffixIcon: Icon(Icons
//                                                           .calendar_today), // Move calendar icon to the end
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(height: 16.0),
//                                       Padding(
//                                         padding: EdgeInsets.only(
//                                             right: 16, bottom: 16),
//                                         child: Align(
//                                           alignment: Alignment.bottomRight,
//                                           child: Container(
//                                             height: 40,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                               gradient: LinearGradient(
//                                                 colors: [
//                                                   Color(0xFF202284),
//                                                   Color(0xFFAB7CAE),
//                                                 ],
//                                                 begin: Alignment.topLeft,
//                                                 end: Alignment.bottomRight,
//                                                 stops: [0.0, 1.0],
//                                                 tileMode: TileMode.clamp,
//                                               ),
//                                             ),
//                                             child: ElevatedButton(
//                                               onPressed: () {
//                                                 // Handle view detail button press
//                                               },
//                                               style: ButtonStyle(
//                                                 backgroundColor:
//                                                     MaterialStateProperty.all(
//                                                         Colors.transparent),
//                                                 shape:
//                                                     MaterialStateProperty.all<
//                                                         RoundedRectangleBorder>(
//                                                   RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             8),
//                                                   ),
//                                                 ),
//                                               ),
//                                               child: Text(
//                                                 '検索する',
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ))
//                         ],
//                       ); // Show the FilterWidget dialog
//                     },
//                   );
//                   // Implement your filter logic here
//                 },
//               ),
//             ),
//           ),
//         ),
//         Container(
//           color: Color.fromARGB(255, 243, 243, 243),
//           padding: const EdgeInsets.only(top: 20.0, right: 16, left: 16),
//           alignment: Alignment.centerRight,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('1-$_upperLimit件目を表示'), // Text before dropdown button
//               SizedBox(
//                   width:
//                       16), // Add some space between the text and dropdown button
//               Row(
//                 children: [
//                   Text('1ページあたりの表示件数'),
//                   SizedBox(width: 8), // Adjust the width as needed
//                   Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                           color: Colors.grey), // Add border decoration
//                       borderRadius: BorderRadius.circular(
//                           4.0), // Add border radius if needed
//                     ),
//                     child: SizedBox(
//                       width: 80,
//                       height: 30, // Adjust the width and height as needed
//                       child: Center(
//                         child: DropdownButton<int>(
//                           value: _rowsPerPage,
//                           onChanged: (value) {
//                             changeRowsPerPage(value!);
//                           },
//                           underline: SizedBox(), // Remove the underline
//                           icon: Icon(Icons.arrow_drop_down), // Set custom icon
//                           focusColor: Colors.transparent, // Remove active color

//                           items:
//                               [10, 15, 20].map<DropdownMenuItem<int>>((value) {
//                             return DropdownMenuItem<int>(
//                               value: value,
//                               child: Text('$value'),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: Container(
//             color: Color.fromARGB(255, 243, 243, 243),
//             padding: const EdgeInsets.only(top: 10.0, right: 20, left: 20),
//             child: SingleChildScrollView(
//               child: Table(
//                 children: [
//                   // Header row
//                   TableRow(
//                     decoration: BoxDecoration(
//                       border: Border(
//                         bottom: BorderSide(color: Colors.grey),
//                       ), // Add borders to the row
//                     ),
//                     children: [
//                       TableCell(child: Center(child: Text(''))),
//                       TableCell(child: Center(child: Text('クライアント'))),
//                       TableCell(child: Center(child: Text('アイテム数'))),
//                       TableCell(child: Center(child: Text('合計金額'))),
//                       TableCell(child: Center(child: Text('下書き作成者'))),
//                       TableCell(child: Center(child: Text('下書き保存日'))),
//                       TableCell(child: Center(child: Text('希望納品日'))),
//                       TableCell(child: Center(child: Text(''))),
//                     ],
//                   ),
//                   // Data rows
//                   if (_filteredData != null && _filteredData.isNotEmpty)
//                     for (var data in _filteredData.sublist(
//                         (_currentPage - 1) * _rowsPerPage,
//                         min((_currentPage * _rowsPerPage),
//                             _filteredData.length)))
//                       TableRow(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border(
//                             top: BorderSide(
//                               width:
//                                   8, // Adjust the width of the border as needed
//                               color: Color.fromARGB(255, 243, 243, 243),
//                             ),
//                             bottom: BorderSide(
//                               width:
//                                   5, // Adjust the width of the border as needed
//                               color: Color.fromARGB(255, 243, 243, 243),
//                             ),
//                           ),
//                         ),
//                         children: [
//                           TableCell(
//                             child: SizedBox(
//                               width: 200, // Set your desired width here
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                   top: 11.0,
//                                   bottom: 9.0,
//                                 ),
//                                 child: Center(
//                                   child: OutlinedButton(
//                                     onPressed: () {},
//                                     style: OutlinedButton.styleFrom(
//                                       side: BorderSide(
//                                         color: Color.fromARGB(255, 40, 41, 131),
//                                         width:
//                                             1.0, // Adjust the width of the border as needed
//                                       ),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(4),
//                                       ),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal:
//                                             0.0, // Adjust left and right padding as needed
//                                       ),
//                                       child: Text(
//                                         'FAX依頼',
//                                         style: TextStyle(
//                                           color:
//                                               Color.fromARGB(255, 40, 41, 131),
//                                           fontFamily: 'Hiragino Sans',
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w300,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           TableCell(
//                             child: Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 17.0, bottom: 12),
//                                 child: Text(data['customer'] != null
//                                     ? data['customer']['clientName'] ?? ''
//                                     : ''),
//                               ),
//                             ),
//                           ),
//                           TableCell(
//                             child: Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 17.0, bottom: 12),
//                                 child: Text(data['products'] != null
//                                     ? data['products'].length.toString() ?? ''
//                                     : ''),
//                               ),
//                             ),
//                           ),
//                           TableCell(
//                             child: Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 17.0, bottom: 12),
//                                 child: Text(
//                                   calculateTotalPrice(data),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           TableCell(
//                             child: Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 17.0, bottom: 12),
//                                 child: Text(data['user'] != null
//                                     ? data['user']['name'] ?? ''
//                                     : ''),
//                               ),
//                             ),
//                           ),
//                           TableCell(
//                             child: Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 17.0, bottom: 12),
//                                 child: Text(DateFormat('yyyy/MM/dd').format(
//                                     DateTime.parse(data['created_at'] ?? ''))),
//                               ),
//                             ),
//                           ),
//                           TableCell(
//                             child: Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 17.0, bottom: 12),
//                                 child: Text(
//                                   data['customer']['shippingDate'] != null
//                                       ? DateFormat('yyyy/MM/dd').format(
//                                           DateTime.parse(
//                                               data['customer']['shippingDate']))
//                                       : '', // Format the shipping date if it exists, otherwise use an empty string
//                                 ),
//                               ),
//                             ),
//                           ),
//                           TableCell(
//                             child: SizedBox(
//                               width: 104, // Set your desired width here
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                   top: 11.0,
//                                   bottom: 9.0,
//                                 ),
//                                 child: Center(
//                                   child: DecoratedBox(
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(40),
//                                       gradient: LinearGradient(
//                                         colors: [
//                                           Color(0xFF202284),
//                                           Color(0xFFAB7CAE),
//                                         ],
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.bottomRight,
//                                         stops: [0.0, 1.0],
//                                         tileMode: TileMode.clamp,
//                                       ),
//                                     ),
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         showDetailDialog(data);
//                                       },
//                                       style: ButtonStyle(
//                                         backgroundColor:
//                                             MaterialStateProperty.all(
//                                           Colors.transparent,
//                                         ),
//                                         shape: MaterialStateProperty.all(
//                                           RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(40),
//                                           ),
//                                         ),
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal:
//                                               20.0, // Adjust left and right padding as needed
//                                         ),
//                                         child: Text(
//                                           '詳細',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         Container(
//           color: Color.fromARGB(255, 243, 243, 243),
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   if (_currentPage > 1) {
//                     navigateToPage(_currentPage - 1);
//                   }
//                 },
//                 child: Row(
//                   children: [
//                     Text('最初へ'),
//                     IconButton(
//                       icon: Icon(Icons.chevron_left),
//                       onPressed: () {
//                         if (_currentPage > 1) {
//                           navigateToPage(_currentPage - 1);
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(width: 16), // Add spacing between the buttons
//               ...List.generate(
//                 totalPages,
//                 (index) {
//                   return GestureDetector(
//                     onTap: () {
//                       navigateToPage(index + 1);
//                     },
//                     child: Container(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: index + 1 == _currentPage
//                               ? Color.fromARGB(255, 44, 22, 243)
//                               : Colors.transparent,
//                           width: 2.0,
//                         ),
//                         borderRadius: BorderRadius.circular(4.0),
//                       ),
//                       child: Text(
//                         '${index + 1}',
//                         style: TextStyle(
//                           color: index + 1 == _currentPage
//                               ? Color.fromARGB(255, 44, 22, 243)
//                               : Colors.black,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(width: 16),
//               GestureDetector(
//                 onTap: () {
//                   if (_currentPage < totalPages) {
//                     navigateToPage(_currentPage + 1);
//                   }
//                 },
//                 child: Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.chevron_right),
//                       onPressed: () {
//                         if (_currentPage < totalPages) {
//                           navigateToPage(_currentPage + 1);
//                         }
//                       },
//                     ),
//                     Text('最後へ'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
