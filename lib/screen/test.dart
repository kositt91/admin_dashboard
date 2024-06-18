void _showFilterDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('フィルター'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              // Other filter rows as per your requirement
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                clientFilter = clientFilterController.text;
                // Update other filter variables similarly
                // purchaserFilter = purchaserFilterController.text;
                // orderStartDateFilter = orderStartDateFilterController.text;
                // orderEndDateFilter = orderEndDateFilterController.text;
                // deliveryStartDateFilter = deliveryStartDateFilterController.text;
                // deliveryEndDateFilter = deliveryEndDateFilterController.text;

                filteredOrders = orders.where((order) {
                  final customerName =
                      order['customer']['name']?.toLowerCase() ?? '';
                  final purchaser =
                      order['salePerson']['fullname']?.toLowerCase() ?? '';
                  final orderDate = order['orderDate'] ?? '';
                  final deliveryDate = order['shippingDate'] ?? '';

                  bool matchesClientFilter =
                      customerName.contains(clientFilter.toLowerCase());
                  // Check other filters here

                  return matchesClientFilter /* && other filter conditions */;
                }).toList();
              });

              Navigator.of(context).pop();
            },
            child: Text('検索する'),
          ),
        ],
      );
    },
  );
}
