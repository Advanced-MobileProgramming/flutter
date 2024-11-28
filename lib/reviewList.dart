import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewList extends StatefulWidget {
  final List<Map<String, dynamic>> reviews;

  // 리뷰 리스트를 부모에서 받도록 설정
  ReviewList({required this.reviews});

  @override
  _ReviewListState createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  final TextEditingController _reviewController = TextEditingController();
  double _currentRating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 리뷰 입력 카드
        Card(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
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
                      backgroundImage:
                          AssetImage('image/DefaultProfile.png'), // 기본 프로필 이미지
                    ),
                    SizedBox(width: 10),
                    Row(
                      children: [
                        Text(
                          '닉네임',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '@id',
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
                    hintText: "리뷰를 작성하세요...",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_reviewController.text.isNotEmpty &&
                          _currentRating > 0) {
                        setState(() {
                          widget.reviews.insert(
                            0,
                            {
                              'username': '새 사용자',
                              'content': _reviewController.text,
                              'date': DateTime.now()
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0],
                              'rating': _currentRating.toInt(),
                            },
                          );
                          _reviewController.clear();
                          _currentRating = 0.0;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('리뷰가 등록되었습니다!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('별점과 리뷰 내용을 모두 입력하세요.')),
                        );
                      }
                    },
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
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.reviews.length,
          itemBuilder: (context, index) {
            final review = widget.reviews[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(review['username'][0].toUpperCase()),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review['username'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: List.generate(
                        review['rating'],
                        (index) =>
                            Icon(Icons.star, size: 16, color: Colors.amber),
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      review['content']!,
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
