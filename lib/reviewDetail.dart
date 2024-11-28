import 'package:flutter/material.dart';

class ReviewDetailPage extends StatelessWidget {
  final String title;
  final String author;
  final String review;
  final int rating;

  ReviewDetailPage(
      {required this.title,
      required this.author,
      required this.review,
      required this.rating});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('리뷰 상세',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 126, 113, 159))),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        toolbarHeight: 120.0,
        titleSpacing: 20.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title / $author',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // 별점 표시
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Color.fromARGB(255, 126, 113, 159),
                  size: 24,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              '리뷰:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              review,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
