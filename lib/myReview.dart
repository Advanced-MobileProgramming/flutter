import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'reviewDetail.dart'; // Import the new file

class MyReviewPage extends StatefulWidget {
  final String userId;

  const MyReviewPage({required this.userId});

  @override
  _MyReviewPageState createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage> {
  List<Map<String, dynamic>> reviews = [];
  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  // Firebase에서 리뷰 데이터 가져오기
  Future<void> fetchReviews() async {
    final DatabaseReference reviewsRef =
        FirebaseDatabase.instance.ref("reviews/${widget.userId}");

    try {
      final snapshot = await reviewsRef.get();
      if (snapshot.exists) {
        // snapshot.value의 타입이 Map인 경우 처리
        if (snapshot.value is Map) {
          final data = (snapshot.value as Map).entries.map((entry) {
            return Map<String, dynamic>.from(entry.value as Map);
          }).toList();
          setState(() {
            reviews = data;
          });
        }
        // snapshot.value의 타입이 List인 경우 처리
        else if (snapshot.value is List) {
          final data = (snapshot.value as List)
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList();
          setState(() {
            reviews = data;
          });
        } else {
          setState(() {
            reviews = [];
          });
        }
      } else {
        setState(() {
          reviews = [];
        });
      }
    } catch (e) {
      throw ("Firebase 데이터 가져오기 오류: $e");
    }
  }


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
      body: reviews.isEmpty
          ? Center(
              child: Text(
                '리뷰가 없습니다.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            )
          : SingleChildScrollView(
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
                  _showEditReviewDialog(context, reviews[index], index);
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

  void _showEditReviewDialog(
      BuildContext context, Map<String, dynamic> review, int index) {
    TextEditingController _reviewController = TextEditingController();
    _reviewController.text = review['review'];

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
              onPressed: () async {
                final DatabaseReference reviewsRef =
                    FirebaseDatabase.instance.ref("reviews");
                // Firebase에 current_page 업데이트
                await reviewsRef
                    .child(widget.userId)
                    .child(review["book_id"].toString())
                    .update({"review": _reviewController.text});
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
