import 'package:flutter/material.dart';

class BookReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 독후감',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 126, 113, 159))),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        toolbarHeight: 120.0,
        titleSpacing: 20.0,
      ),
      body: Center(
        child: Text(
          '나의 독후감 페이지입니다.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
