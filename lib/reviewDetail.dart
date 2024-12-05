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
        padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: Color.fromARGB(255, 126, 113, 159), thickness: 0.5),
            SizedBox(height: 16),
            Text(
              '$title',
              style: TextStyle(
                fontSize: 33, 
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 126, 113, 159)
              ),
            ),
            SizedBox(height: 16),
            Text(
              '저자 | $author',
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 126, 113, 159)
              ),
            ),
            SizedBox(height: 16),
            // 별점 표시
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 24,
                ),
              ),
            ),
            SizedBox(height: 16),
            Divider(
              color: Color.fromARGB(255, 126, 113, 159), thickness: 0.5),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.all(16.0), // 원하는 여백 추가
              child: Text(
                review,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 126, 113, 159),
                    fontSize: 14,
                  ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
