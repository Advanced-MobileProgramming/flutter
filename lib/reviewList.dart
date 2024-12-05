import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_database/firebase_database.dart';

class ReviewList extends StatefulWidget {
  final String userId;
  final String nickname;
  final Map<String, dynamic> book;

  // 리뷰 리스트를 부모에서 받도록 설정
  ReviewList(
      {required this.book, required this.userId, required this.nickname});

  @override
  _ReviewListState createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  final TextEditingController _reviewController = TextEditingController();
  double _currentRating = 0.0;
  List<Map<String, dynamic>> reviews = [];
  bool _isReviewSubmitted = false;

  @override
  void initState() {
    super.initState();
    fetchReviewsByBookId(widget.book["id"]);
  }

  void fetchReviewsByBookId(int bookId) async {
    final databaseReference = FirebaseDatabase.instance.ref();

    databaseReference.child('reviews').once().then((event) {
      final snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> getData = snapshot.value as Map<dynamic, dynamic>;
        List<Map<String, dynamic>> matchingReviews = [];
        bool userReviewExists = false;

        // 각 userId와 해당 리뷰를 순회하며 book_id가 일치하는 데이터 찾기
        getData.forEach((userId, userReviews) {
          userReviews.forEach((key, review) {
            if (review['book_id'] == bookId) {
              matchingReviews.add(Map<String, dynamic>.from(review));

              // 로그인한 사용자의 리뷰가 있는지 확인
              if (userId == widget.userId) {
                userReviewExists = true;
              }
            }
          });
        });

        setState(() {
          reviews = matchingReviews
            ..sort((a, b) => DateTime.parse(b['timestamp'])
                .compareTo(DateTime.parse(a['timestamp'])));
          _isReviewSubmitted = userReviewExists;
        });
      } else {
        print("No reviews found in the database.");
      }
    }).catchError((error) {
      print("Error fetching reviews: $error");
    });
  }

  void _submitReview() async {
    if (_reviewController.text.isNotEmpty && _currentRating > 0) {
      final DatabaseReference reviewRef = FirebaseDatabase.instance
          .ref("reviews/${widget.userId}/${widget.book["id"]}");

      await reviewRef.set({
        "user_id": widget.userId,
        "user_nickname": widget.nickname,
        "book_id": widget.book["id"],
        "book_image": widget.book["image_path"],
        "book_title": widget.book["title"],
        "book_author": widget.book["author"],
        "review": _reviewController.text,
        'date': DateTime.now().toLocal().toString().split(' ')[0],
        'rating': _currentRating.toInt(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      setState(() {
        _reviewController.text = "";
        _currentRating = 0.0;
        _isReviewSubmitted = true; // 리뷰 작성 후 입력 폼 숨김
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('리뷰가 등록되었습니다!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('별점과 리뷰 내용을 모두 입력하세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 리뷰 입력 카드
        // 리뷰 입력 카드 (사용자가 이미 리뷰를 남겼다면 숨김)
        if (!_isReviewSubmitted)
          Card(
            color: const Color.fromARGB(255, 247, 241, 250),
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('image/DefaultProfile.png'),
                      ),
                      SizedBox(width: 10),
                      Row(
                        children: [
                          Text(
                            widget.nickname,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(width: 5),
                          Text(
                            '@${widget.userId}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      Spacer(),
                      RatingBar.builder(
                        initialRating: 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _currentRating = rating;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      hintText: '리뷰를 작성하세요...',
                      filled: true,
                      fillColor: Color.fromARGB(255, 250, 248, 250),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _submitReview,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 126, 113, 159),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text(
                        '리뷰 등록',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // 리뷰 목록
        reviews.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20), // 위쪽에 간격 추가
                    Text(
                      '작성된 리뷰가 없습니다.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Card(
                    color: Color.fromARGB(255, 247, 241, 250),
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // 둥근 모서리 설정
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(review['user_nickname'][0].toUpperCase()),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            review['user_nickname'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: List.generate(
                              review['rating'],
                              (index) => Icon(Icons.star,
                                  size: 16, color: Colors.amber),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Text(
                            review['review']!,
                            style: TextStyle(color: Colors.black87),
                          ),
                          SizedBox(height: 5),
                          Text(
                            review['date']!,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
