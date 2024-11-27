import 'package:flutter/material.dart';
import 'reviewDetail.dart'; // Import the new file

class MyReviewPage extends StatefulWidget {
  @override
  _MyReviewPageState createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage> {
  List<Map<String, dynamic>> reviews = [
    {
      'title': '책 제목 1',
      'author': '저자 1',
      'rating': 4,
      'review': '이 책은 정말 훌륭했습니다.'
    },
    {
      'title': '책 제목 2',
      'author': '저자 2',
      'rating': 3,
      'review': '좋은 책이었지만 아쉬운 점이 많았어요.'
    },
    {
      'title': '책 제목 3',
      'author': '저자 3',
      'rating': 5,
      'review': '정말 추천하는 책입니다!'
    },
    {
      'title': '책 제목 4',
      'author': '저자 4',
      'rating': 5,
      'review': '정말 추천하는 책입니다!'
    },
    {
      'title': '책 제목 5',
      'author': '저자 5',
      'rating': 5,
      'review': '정말 추천하는 책입니다!'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '나의 리뷰',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 126, 113, 159),
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        toolbarHeight: 120.0,
        titleSpacing: 20.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            ...List.generate(reviews.length, (i) {
              return Column(
                children: [
                  _buildBookCard(
                    reviews[i]['title'],
                    reviews[i]['author'],
                    Color.fromARGB(235, 234, 229, 239),
                    Color.fromARGB(255, 126, 113, 159),
                    reviews[i]['rating'],
                    reviews[i]['review'],
                    i,
                  ),
                  if (i < reviews.length - 1) SizedBox(height: 16),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(String title, String author, Color backgroundColor,
      Color textColor, int rating, String review, int index) {
    return GestureDetector(
      onTap: () {
        // 카드를 탭하면 전체 리뷰 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewDetailPage(
              title: title,
              author: author,
              review: review,
              rating: rating,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            height: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$title / $author',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Row(
                      children: [
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
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.more_vert),
                          color: Colors.black,
                          onPressed: () {
                            _showMoreOptions(context, index);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '"$review"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit, color: Colors.blue),
                title: Text('수정', style: TextStyle(color: Colors.blue)),
                onTap: () {
                  Navigator.pop(context);
                  _showEditReviewDialog(context, index);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('삭제', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditReviewDialog(BuildContext context, int index) {
    TextEditingController _reviewController = TextEditingController();
    _reviewController.text = reviews[index]['review'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('리뷰 수정'),
          content: TextField(
            controller: _reviewController,
            maxLines: 3,
            decoration: InputDecoration(hintText: "리뷰를 수정하세요."),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  reviews[index]['review'] = _reviewController.text;
                });
                Navigator.pop(context);
              },
              child: Text('수정'),
            ),
          ],
        );
      },
    );
  }
}
