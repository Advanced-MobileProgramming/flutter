import 'package:flutter/material.dart';

class MyReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 리뷰',
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
          '내가 쓴 리뷰 페이지입니다.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
