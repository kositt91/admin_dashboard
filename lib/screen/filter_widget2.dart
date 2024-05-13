import 'package:flutter/material.dart';

class FilterWidget2 extends StatefulWidget {
  @override
  _FilterWidget2State createState() => _FilterWidget2State();
}

class _FilterWidget2State extends State<FilterWidget2> {
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                                  decoration: InputDecoration(
                                    hintText: 'Start Date',
                                    suffixIcon: Icon(Icons
                                        .calendar_today), // Move calendar icon to the end
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
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'End Date',
                                    suffixIcon: Icon(Icons
                                        .calendar_today), // Move calendar icon to the end
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
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Start Date',
                                    suffixIcon: Icon(Icons
                                        .calendar_today), // Move calendar icon to the end
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
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'End Date',
                                    suffixIcon: Icon(Icons
                                        .calendar_today), // Move calendar icon to the end
                                  ),
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
                              // Handle view detail button press
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
            ))
      ],
    );
  }
}
