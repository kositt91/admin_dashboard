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
                            // // Generate PDF and download
                            // await _generateAndDownloadPDF(context, draftDetail);
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
                                  '${orderDetail['shippingDate']}' != null
                                      ? DateFormat('yyyy/MM/dd').format(
                                          DateTime.parse(
                                              orderDetail['shippingDate']))
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
                                        '${orderDetail['customer']['phone']}')),
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
                                          orderDetail['shippingDate'] ?? '')))),
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
                            255, 224, 224, 226)), // Add borders to the tabler
                    children: [
                      // Table header
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              color: Color(
                                  0x23131314), // Background color for the cell
                              child: const Center(
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
                              child: const Center(
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
                              child: const Center(
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
                              child: const Center(
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
                              child: const Center(
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
                              child: const Center(
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
                      for (var product in orderDetail['products'])
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
                                  child: Text(product['jancd'] ?? ''),
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
                                    product['productPrice']?.toString() ?? '',
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