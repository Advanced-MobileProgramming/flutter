// 책장에 저장되지 않은 책의 상세정보 페이지
import 'package:flutter/material.dart';

class UnstoredBookDetail extends StatelessWidget {
  final String title;
  final String image;
  final String author;
  final String description;
  final String status;
  final double progress;
  final String startDay;
  final String endDay;

  UnstoredBookDetail({
    required this.title,
    required this.image,
    required this.author,
    required this.description,
    required this.status,
    required this.progress,
    required this.startDay,
    required this.endDay,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 126, 113, 159),
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color.fromARGB(255, 126, 113, 159)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  image,
                  width: 200,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.image, size: 100, color: Colors.grey);
                  },
                ),
              ),
              SizedBox(height: 16),
              Text(
                "저자: $author",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "설명: $description",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                "상태: $status",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                color: Colors.purple,
              ),
              SizedBox(height: 8),
              Text("읽기 진행률: ${(progress * 100).toStringAsFixed(1)}%"),
              SizedBox(height: 16),
              Text("시작일: $startDay"),
              Text("종료일: $endDay"),
            ],
          ),
        ),
      ),
    );
  }
}