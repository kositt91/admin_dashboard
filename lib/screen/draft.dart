import 'package:flutter/material.dart';
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

class DraftPage extends StatefulWidget {
  @override
  _DraftPageState createState() => _DraftPageState();
}

class _DraftPageState extends State<DraftPage> {
  late List<dynamic> orders = [];
  int _rowsPerPage = 10;
  int _currentPage = 1;
  int totalPages = 0; // Initialize totalPages with a default value
  int totalItems = 0;
  late int itemsPerPage;
  late List<dynamic> filteredOrders = [];
  pw.Font? _notoSanFont;
  String clientFilter = ''; // Initialize with an empty string
  String purchaserFilter = '';
  String orderStartDateFilter = '';
  String orderEndDateFilter = '';
  String deliveryStartDateFilter = '';
  String deliveryEndDateFilter = '';
  TextEditingController clientFilterController = TextEditingController();
  TextEditingController purchaserFilterController = TextEditingController();
  TextEditingController orderStartDateFilterController =
      TextEditingController();
  TextEditingController orderEndDateFilterController = TextEditingController();
  TextEditingController deliveryStartDateFilterController =
      TextEditingController();
  TextEditingController deliveryEndDateFilterController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchData();
    loadFont();
  }

  Future<void> fetchData() async {
    final authToken = await TokenManager.getAccessToken();
    final response = await http.get(
      Uri.parse(
          'https://rfqos.internal.engineerforce.io/api/v1/user/admin-drafts/'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        orders = data;
        totalItems = orders.length;
        filteredOrders = List.from(orders); // Initialize filteredOrders here
        updatePagination();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void changeRowsPerPage(int value) {
    setState(() {
      _rowsPerPage = value;
      _currentPage = 1; // Reset to the first page whenever rows per page change
      updatePagination();
    });
  }

  void navigateToPage(int page) {
    setState(() {
      _currentPage = page;
      updatePagination();
    });
  }

  void updatePagination() {
    totalPages = (filteredOrders.length / _rowsPerPage).ceil();
  }

  String calculateTotalAmount(Map<String, dynamic> order) {
    double total = 0;
    for (var product in order['products']) {
      total += product['quantity'] * product['productPrice'];
    }
    // Use NumberFormat to specify the desired format with comma as the decimal separator
    final format = NumberFormat('#,##0', 'en_US');
    return format.format(
        total); // Return total amount as a string in the specified format
  }

  void filterOrders(String searchText) {
    setState(() {
      filteredOrders = orders.where((order) {
        final customerName =
            order['customer']['name']?.toString()?.toLowerCase() ?? '';
        final customerBranch =
            order['customer']['branch']?.toString()?.toLowerCase() ?? '';
        final salePersonName =
            order['salePerson']['fullname']?.toString()?.toLowerCase() ?? '';

        bool matchesSearchText =
            customerName.contains(searchText.toLowerCase()) ||
                customerBranch.contains(searchText.toLowerCase()) ||
                salePersonName.contains(searchText.toLowerCase());

        bool matchesClientFilter = clientFilter.isEmpty ||
            customerName.contains(clientFilter.toLowerCase());
        bool matchesPurchaserFilter = purchaserFilter.isEmpty ||
            salePersonName.contains(purchaserFilter.toLowerCase());

        bool matchesOrderDateFilter = (orderStartDateFilter.isEmpty ||
                order['created'].compareTo(orderStartDateFilter) >= 0) &&
            (orderEndDateFilter.isEmpty ||
                order['created'].compareTo(orderEndDateFilter) <= 0);

        bool matchesDeliveryDateFilter = (deliveryStartDateFilter.isEmpty ||
                order['created'].compareTo(deliveryStartDateFilter) >= 0) &&
            (deliveryEndDateFilter.isEmpty ||
                order['created'].compareTo(deliveryEndDateFilter) <= 0);

        return matchesSearchText &&
            matchesClientFilter &&
            matchesPurchaserFilter &&
            matchesOrderDateFilter &&
            matchesDeliveryDateFilter;
      }).toList();
    });
  }

  Future<void> loadFont() async {
    ByteData fontData = await rootBundle.load("/fonts/notosan.ttf");
    setState(() {
      _notoSanFont = pw.Font.ttf(fontData);
    });
  }

// Create a PDF document
  Future<void> _generateAndDownloadPDF(
      BuildContext context, Map<String, dynamic> orderDetail) async {
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
                              '${orderDetail['salePerson']['fullname']}',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                fontFallback: [
                                  _notoSanFont ??
                                      pw.Font
                                          .helvetica(), // Use Helvetica as a fallback font
                                ],
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
                              '${orderDetail['customer']['name']}',
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
                                    '  ¥  ${calculateTotalAmount(orderDetail)}',
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
                                    child: pw.Text('${orderDetail['orderId']}',
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
                                    child: pw.Text('${orderDetail['pk']}',
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
                                        '${orderDetail['customer']['branch']}',
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
                                    orderDetail['updated'] != null &&
                                            orderDetail['updated'].isNotEmpty
                                        ? DateFormat('yyyy/MM/dd').format(
                                            DateTime.parse(
                                                orderDetail['updated']))
                                        : '', // Format the shipping date if it exists, otherwise use an empty string
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
                                        '${orderDetail['customer']['phone']}',
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
                                    orderDetail['shippingDate'] != null &&
                                            orderDetail['shippingDate']
                                                .isNotEmpty
                                        ? DateFormat('yyyy/MM/dd').format(
                                            DateTime.parse(
                                                orderDetail['shippingDate']))
                                        : '', // Format the shipping date if it exists, otherwise use an empty string
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
                                    '〒  ${orderDetail['customer']['phone']}',
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
                                    '${orderDetail['customer']['address']}',
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
                          '備考   ${orderDetail['remark'] ?? 'N/A'}',
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
                          'コメント   ${orderDetail['comment'] ?? 'N/A'}',
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
                        for (var product in orderDetail['products'])
                          pw.TableRow(
                            decoration: pw.BoxDecoration(
                                // Add borders to the row
                                ),
                            children: [
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.all(8.0),
                                  child: pw.Text(product['jancd'] ?? ''),
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
                                      product['productPrice']?.toString() ??
                                          ''),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.all(8.0),
                                  child: pw.Text(
                                    ((product['quantity'] ?? 0) *
                                            (product['productPrice'] ?? 0))
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

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, Function(String) onDateSelected) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      String formattedDate = "${picked.toLocal()}".split(' ')[0];
      setState(() {
        controller.text = formattedDate;
        onDateSelected(formattedDate);
      });
    }
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
                                  child: TextField(
                                    controller: clientFilterController,
                                    onChanged: (value) {
                                      setState(() {
                                        clientFilter = value;
                                      });
                                    },
                                    decoration: InputDecoration(),
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
                                  child: TextField(
                                    controller: purchaserFilterController,
                                    onChanged: (value) {
                                      setState(() {
                                        purchaserFilter = value;
                                      });
                                    },
                                    decoration: InputDecoration(),
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
                                  child: TextField(
                                    controller: orderStartDateFilterController,
                                    decoration: InputDecoration(
                                      hintText: '2024-05-01',
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.calendar_today),
                                        onPressed: () {
                                          _selectDate(context,
                                              orderStartDateFilterController,
                                              (value) {
                                            setState(() {
                                              orderStartDateFilter = value;
                                              filterOrders(orderEndDateFilter);
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        orderStartDateFilter = value;
                                        filterOrders(orderEndDateFilter);
                                      });
                                    },
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
                                  child: TextField(
                                    controller: orderEndDateFilterController,
                                    decoration: InputDecoration(
                                      hintText: '2024-05-01',
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.calendar_today),
                                        onPressed: () {
                                          _selectDate(context,
                                              orderEndDateFilterController,
                                              (value) {
                                            setState(() {
                                              orderEndDateFilter = value;
                                              filterOrders(orderEndDateFilter);
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        orderEndDateFilter = value;
                                        filterOrders(orderEndDateFilter);
                                      });
                                    },
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
                                  child: TextField(
                                    controller:
                                        deliveryStartDateFilterController,
                                    decoration: InputDecoration(
                                      hintText: '2024-05-01',
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.calendar_today),
                                        onPressed: () {
                                          _selectDate(context,
                                              deliveryStartDateFilterController,
                                              (value) {
                                            setState(() {
                                              deliveryStartDateFilter = value;
                                              filterOrders(
                                                  deliveryStartDateFilter);
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        deliveryStartDateFilter = value;
                                        filterOrders(deliveryStartDateFilter);
                                      });
                                    },
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
                                  child: TextField(
                                    controller: deliveryEndDateFilterController,
                                    decoration: InputDecoration(
                                      hintText: '2024-05-01',
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.calendar_today),
                                        onPressed: () {
                                          _selectDate(context,
                                              deliveryEndDateFilterController,
                                              (value) {
                                            setState(() {
                                              deliveryEndDateFilter = value;
                                              filterOrders(
                                                  deliveryEndDateFilter);
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        deliveryEndDateFilter = value;
                                        filterOrders(deliveryEndDateFilter);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
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
                                colors: const [
                                  Color(0xFF202284),
                                  Color(0xFFAB7CAE),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: const [0.0, 1.0],
                                tileMode: TileMode.clamp,
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  clientFilter = clientFilterController.text;
                                  String purchaserFilter =
                                      purchaserFilterController.text;
                                  String orderStartDateFilter =
                                      orderStartDateFilterController.text;
                                  String orderEndDateFilter =
                                      orderEndDateFilterController.text;
                                  String deliveryStartDateFilter =
                                      deliveryStartDateFilterController.text;
                                  String deliveryEndDateFilter =
                                      deliveryEndDateFilterController.text;

                                  filteredOrders = orders.where((order) {
                                    final customerName = order['customer']
                                                ['name']
                                            ?.toLowerCase() ??
                                        '';
                                    final purchaser = order['salePerson']
                                                ['fullname']
                                            ?.toLowerCase() ??
                                        '';
                                    final orderDate = order['created'] ?? '';
                                    final deliveryDate =
                                        order['shippingDate'] ?? '';

                                    bool matchesClientFilter = customerName
                                        .contains(clientFilter.toLowerCase());
                                    bool matchesPurchaserFilter =
                                        purchaser.contains(
                                            purchaserFilter.toLowerCase());
                                    bool matchesOrderDateFilter =
                                        (orderStartDateFilter.isEmpty ||
                                                orderDate.compareTo(
                                                        orderStartDateFilter) >=
                                                    0) &&
                                            (orderEndDateFilter.isEmpty ||
                                                orderDate.compareTo(
                                                        orderEndDateFilter) <=
                                                    0);

                                    bool matchesDeliveryDateFilter = true;
                                    if (deliveryDate.isNotEmpty) {
                                      final deliveryDateParsed =
                                          DateTime.parse(deliveryDate);
                                      final deliveryStartDateParsed =
                                          deliveryStartDateFilter.isNotEmpty
                                              ? DateTime.parse(
                                                  deliveryStartDateFilter)
                                              : null;
                                      final deliveryEndDateParsed =
                                          deliveryEndDateFilter.isNotEmpty
                                              ? DateTime.parse(
                                                  deliveryEndDateFilter)
                                              : null;

                                      matchesDeliveryDateFilter =
                                          (deliveryStartDateParsed == null ||
                                                  deliveryDateParsed.isAfter(
                                                      deliveryStartDateParsed) ||
                                                  deliveryDateParsed
                                                      .isAtSameMomentAs(
                                                          deliveryStartDateParsed)) &&
                                              (deliveryEndDateParsed == null ||
                                                  deliveryDateParsed.isBefore(
                                                      deliveryEndDateParsed) ||
                                                  deliveryDateParsed
                                                      .isAtSameMomentAs(
                                                          deliveryEndDateParsed));
                                    }

                                    return matchesClientFilter &&
                                        matchesPurchaserFilter &&
                                        matchesOrderDateFilter &&
                                        matchesDeliveryDateFilter;
                                  }).toList();
                                });

                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                elevation: MaterialStateProperty.all(0),
                                shape: MaterialStateProperty.all(
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
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterItem(
      String text, Color backgroundColor, VoidCallback onClear) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
            BorderRadius.circular(20), // Adjust border radius as needed
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(color: Colors.white), // Text color
          ),
          SizedBox(width: 8),
          InkWell(
            onTap: onClear,
            child: Icon(
              Icons.close,
              color: Colors.white, // Close button color
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  void showDetailDialog(Map<String, dynamic> orderDetail) {
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
                          onPressed: () async {
                            // Generate PDF and download
                            await _generateAndDownloadPDF(context, orderDetail);
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
                            '${orderDetail['salePerson']['fullname']}',
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
                            '${orderDetail['customer']['name']}',
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
                              text: '  ¥  ${calculateTotalAmount(orderDetail)}',
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
                                    child: Text('${orderDetail['orderId']}')),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: SizedBox(
                                height: 40, // Adjust the height as needed
                                child:
                                    Center(child: Text('${orderDetail['pk']}')),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: SizedBox(
                                height: 40, // Adjust the height as needed
                                child: Center(
                                    child: Text(
                                        '${orderDetail['customer']['branch']}')),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: SizedBox(
                                height: 40, // Adjust the height as needed
                                child: Center(
                                  child: Text(
                                    orderDetail['shippingDate'] != null &&
                                            orderDetail['shippingDate']
                                                .isNotEmpty
                                        ? DateFormat('yyyy/MM/dd').format(
                                            DateTime.parse(
                                                orderDetail['shippingDate']))
                                        : '', // Format the shipping date if it exists, otherwise use an empty string
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: SizedBox(
                                height: 40, // Adjust the height as needed
                                child: Center(
                                    child: Text(
                                        '${orderDetail['customer']['phone']}')),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: SizedBox(
                                height: 40, // Adjust the height as needed
                                child: Center(
                                  child: Text(
                                    orderDetail['updated'] != null &&
                                            orderDetail['updated'].isNotEmpty
                                        ? DateFormat('yyyy/MM/dd').format(
                                            DateTime.parse(
                                                orderDetail['updated']))
                                        : '', // Format the shipping date if it exists, otherwise use an empty string
                                  ),
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
                        color: const Color.fromARGB(
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
                                        '〒  ${orderDetail['customer']['phone']}')),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: SizedBox(
                                height: 40, // Adjust the height as needed
                                child: Center(
                                    child: Text(
                                        '${orderDetail['customer']['address']}')),
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
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromARGB(255, 224, 224, 226),
                          ),
                        ),
                      ),
                      child: Text('備考   ${orderDetail['remark']}'),
                    ),
                  ),
                ),
                Container(
                  width: 600,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Color.fromARGB(255, 224, 224, 226)),
                        ),
                      ),
                      child: Text('コメント   ${orderDetail['comment']}'),
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
                          255, 224, 224, 226), // Add borders to the table
                    ),
                    columnWidths: {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(6),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(1),
                      5: FlexColumnWidth(1),
                    },
                    children: [
                      // Table header
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('JANコード'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('型番'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('品名'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: const Center(
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('数量'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: const Center(
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('価格'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: const Center(
                                child: SizedBox(
                                  height: 40, // Adjust the height as needed
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('金額'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Table rows
                      for (var product in orderDetail['products'])
                        TableRow(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey), // Add borders to the row
                          ),
                          children: [
                            TableCell(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(product['jancd'] ?? ''),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(product['productCode'] ?? ''),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Align(
                                alignment: Alignment.centerLeft,
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
                                      product['productPrice']?.toString() ??
                                          ''),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    ((product['quantity'] ?? 0) *
                                            (product['productPrice'] ?? 0))
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

  @override
  Widget build(BuildContext context) {
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = (_currentPage * _rowsPerPage);
    final displayedOrders = filteredOrders.sublist(
      startIndex,
      endIndex > filteredOrders.length ? filteredOrders.length : endIndex,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Color.fromARGB(255, 243, 243, 243),
          padding: const EdgeInsets.only(top: 50.0, left: 16, right: 16),
          child: Text(
            '下書き一覧',
            style: TextStyle(
              fontFamily: 'Noto Sans JP',
              fontSize: 26.0,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
        ),
        Container(
          color: Color.fromARGB(255, 243, 243, 243),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
          child: TextField(
            onChanged: (value) {
              filterOrders(value);
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
          color: Color.fromARGB(255, 243, 243,
              243), // Example color, replace with your desired color
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                if (clientFilter.isNotEmpty) ...[
                  _buildFilterItem(clientFilter, Color(0xFF292786), () {
                    setState(() {
                      clientFilter = '';
                      filterOrders(clientFilter);
                    });
                  }),
                  SizedBox(width: 10),
                ],
                if (purchaserFilter.isNotEmpty) ...[
                  _buildFilterItem(purchaserFilter, Color(0xFF292786), () {
                    setState(() {
                      purchaserFilter = '';
                      filterOrders(purchaserFilter);
                    });
                  }),
                  SizedBox(width: 10),
                ],
                if (orderStartDateFilter.isNotEmpty ||
                    orderEndDateFilter.isNotEmpty) ...[
                  _buildFilterItem(
                    '下書き保存日：$orderStartDateFilter ~ $orderEndDateFilter',
                    Color(0xFF292786),
                    () {
                      setState(() {
                        orderStartDateFilter = '';
                        orderEndDateFilter = '';
                        filterOrders(orderStartDateFilter);
                      });
                    },
                  ),
                  SizedBox(width: 10),
                ],
                if (deliveryStartDateFilter.isNotEmpty ||
                    deliveryEndDateFilter.isNotEmpty) ...[
                  _buildFilterItem(
                    '希望納品日：$deliveryStartDateFilter ~ $deliveryEndDateFilter',
                    Color(0xFF292786),
                    () {
                      setState(() {
                        deliveryStartDateFilter = '';
                        deliveryEndDateFilter = '';
                        filterOrders(deliveryStartDateFilter);
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
        Container(
          color: Color.fromARGB(255, 243, 243, 243),
          padding: const EdgeInsets.only(top: 10.0, right: 16, left: 16),
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1-${displayedOrders.length}件目を表示'),
              SizedBox(width: 16),
              Row(
                children: [
                  Text('1ページあたりの表示件数'),
                  SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: SizedBox(
                      width: 80,
                      height: 30,
                      child: Center(
                          child: DropdownButton<int>(
                        value: _rowsPerPage,
                        onChanged: (value) {
                          changeRowsPerPage(value!);
                        },
                        underline:
                            SizedBox(), // Correctly placed underline property
                        icon: Icon(Icons.arrow_drop_down),
                        focusColor: Colors.transparent,
                        items: [10, 15, 20].map<DropdownMenuItem<int>>((value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value'),
                          );
                        }).toList(),
                      )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
          child: Container(
            color: Color.fromARGB(255, 243, 243, 243),
          ),
        ),
        Expanded(
          child: Container(
            color: Color.fromARGB(255, 243, 243, 243),
            child: Stack(
              children: [
                Container(
                  color: Color.fromARGB(255, 243, 243, 243),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          SizedBox(height: 24),
                          Table(
                            columnWidths: const {
                              0: FlexColumnWidth(3),
                              1: FlexColumnWidth(4),
                              2: FlexColumnWidth(2),
                              3: FlexColumnWidth(2),
                              4: FlexColumnWidth(4),
                              5: FlexColumnWidth(2),
                              6: FlexColumnWidth(2),
                              7: FlexColumnWidth(3),
                            },
                            children: [
                              for (var order in displayedOrders)
                                TableRow(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      top: BorderSide(
                                        width: 8,
                                        color:
                                            Color.fromARGB(255, 243, 243, 243),
                                      ),
                                      bottom: BorderSide(
                                        width: 5,
                                        color:
                                            Color.fromARGB(255, 243, 243, 243),
                                      ),
                                    ),
                                  ),
                                  children: [
                                    TableCell(
                                      child: SizedBox(
                                        width: 200,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 11.0,
                                            bottom: 9.0,
                                          ),
                                          child: Center(
                                            child: OutlinedButton(
                                              onPressed: () {},
                                              style: OutlinedButton.styleFrom(
                                                side: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 40, 41, 131),
                                                  width: 1.0,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 0.0,
                                                ),
                                                child: Text(
                                                  'FAX依頼',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 40, 41, 131),
                                                    fontFamily: 'Hiragino Sans',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 17.0, bottom: 12),
                                          child: Text(
                                              order['customer']['name'] ?? ''),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 17.0, bottom: 12),
                                          child: Text(
                                            '${order['products'].length}',
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 17.0, bottom: 12),
                                          child: Text(
                                            calculateTotalAmount(order),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 17.0, bottom: 12),
                                          child: Text(order['salePerson']
                                                  ['fullname'] ??
                                              ''),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 17.0, bottom: 12),
                                          child: Text(
                                            order['updated'] != null &&
                                                    order['updated'].isNotEmpty
                                                ? DateFormat('yyyy/MM/dd')
                                                    .format(DateTime.parse(
                                                        order['updated']))
                                                : '',
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 17.0, bottom: 12),
                                          child: Text(
                                            order['shippingDate'] != null &&
                                                    order['shippingDate']
                                                        .isNotEmpty
                                                ? DateFormat('yyyy/MM/dd')
                                                    .format(DateTime.parse(
                                                        order['shippingDate']))
                                                : '',
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: SizedBox(
                                        width: 200,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 11.0, bottom: 9.0),
                                          child: Center(
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                gradient: const LinearGradient(
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
                                                  showDetailDialog(order);
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    Colors.transparent,
                                                  ),
                                                  shape:
                                                      MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 20.0,
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
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 20,
                  right: 20,
                  child: Container(
                    color: Color.fromARGB(255, 243, 243, 243),
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(4),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(2),
                        4: FlexColumnWidth(4),
                        5: FlexColumnWidth(2),
                        6: FlexColumnWidth(2),
                        7: FlexColumnWidth(3),
                      },
                      children: const [
                        TableRow(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          ),
                          children: [
                            TableCell(child: Center(child: Text(''))),
                            TableCell(child: Center(child: Text('クライアント'))),
                            TableCell(child: Center(child: Text('アイテム数'))),
                            TableCell(child: Center(child: Text('合計金額'))),
                            TableCell(child: Center(child: Text('下書き作成者'))),
                            TableCell(child: Center(child: Text('下書き保存日'))),
                            TableCell(child: Center(child: Text('希望納品日'))),
                            TableCell(child: Center(child: Text(''))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Color.fromARGB(255, 243, 243, 243),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  '全$totalItems件',
                ),
              ),
              SizedBox(
                width: 30,
              ),
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
                      onPressed: _currentPage > 1
                          ? () {
                              if (_currentPage > 1) {
                                navigateToPage(_currentPage - 1);
                              }
                            }
                          : null,
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
                          fontFamily: 'Hira',
                          fontWeight: index + 1 == _currentPage
                              ? FontWeight.bold
                              : FontWeight.normal,
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
                      onPressed: _currentPage < totalPages
                          ? () {
                              if (_currentPage < totalPages) {
                                navigateToPage(_currentPage + 1);
                              }
                            }
                          : null,
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
          child: Container(
            color: Color.fromARGB(255, 243, 243, 243),
          ),
        ),
      ],
    );
  }
}
