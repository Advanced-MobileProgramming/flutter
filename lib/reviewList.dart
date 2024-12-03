import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewList extends StatefulWidget {
  final String userId;
  final String nickname;
  final List<Map<String, dynamic>> reviews;

  // 리뷰 리스트를 부모에서 받도록 설정
  ReviewList(
      {required this.reviews, required this.userId, required this.nickname});

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
          color: const Color.fromARGB(255, 247, 241, 250),
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // 둥근 모서리 설정
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
                      backgroundImage:
                          AssetImage('image/DefaultProfile.png'), // 기본 프로필 이미지
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
                    filled: true, // 배경색 활성화
                    fillColor: Color.fromARGB(255, 250, 248, 250), // 배경색 설정
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), // 둥근 모서리
                      borderSide: BorderSide.none, // 테두리 제거
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // 둥근 모서리
                      borderSide: BorderSide.none, // 비활성 상태 테두리 제거
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // 둥근 모서리
                      borderSide: BorderSide.none, // 포커스 상태 테두리 제거
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 15,
                    ), // 입력 필드 여백 설정
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
                              'username': widget.nickname,
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

        // 리뷰 목록
        widget.reviews.isEmpty
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
                itemCount: widget.reviews.length,
                itemBuilder: (context, index) {
                  final review = widget.reviews[index];
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
