import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UnstoredBookDetail extends StatefulWidget {
  final String title;
  final String image;
  final String author;
  final String description;
  final String status;
  final double progress;
  final String startDay;
  final String endDay;
  final String publisher;
  final String publishYear;
  final String publishMonth;

  UnstoredBookDetail({
    required this.title,
    required this.image,
    required this.author,
    required this.description,
    required this.status,
    required this.progress,
    required this.startDay,
    required this.endDay,
    required this.publisher,
    required this.publishYear,
    required this.publishMonth,
  });

  @override
  _UnstoredBookDetailState createState() => _UnstoredBookDetailState();
}

class _UnstoredBookDetailState extends State<UnstoredBookDetail> {
  int _currentTabIndex = 0; // 세그먼트 바 초기값

  // 샘플 리뷰 데이터
  final List<Map<String, dynamic>> reviews = [
    {
      "username": "user1",
      "content": "이 책은 정말 유익하고 재미있었습니다!",
      "date": "2024-11-27",
      "rating": 5,
    },
    {
      "username": "user2",
      "content": "조금 지루한 부분도 있었지만, 전반적으로 괜찮았어요.",
      "date": "2024-11-26",
      "rating": 3,
    },
    {
      "username": "user3",
      "content": "글이 어렵지 않고 쉽게 읽을 수 있었습니다.",
      "date": "2024-11-25",
      "rating": 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '책 상세정보',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 126, 113, 159),
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // 뒤로 가기 버튼 비활성화
        toolbarHeight: 120.0,
        titleSpacing: 20.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 126, 113, 159),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 20.0, right: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar 밑줄
              Divider(
                  color: Color.fromARGB(255, 126, 113, 159), thickness: 0.5),
              SizedBox(height: 15),

              // 상단 섹션 (이미지, 제목, 저자, 출판연도)
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 책 이미지
                    Container(
                      width: 120,
                      height: 180,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // 그림자 색상
                            spreadRadius: 1, // 그림자 확산 범위
                            blurRadius: 5, // 그림자 흐림 정도
                            offset: Offset(0, 4), // 그림자의 위치 (x, y)
                          ),
                        ],
                      ),
                      child: Image.asset(
                        widget.image,
                        width: 120,
                        height: 160,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.image,
                              size: 100, color: Colors.grey);
                        },
                      ),
                    ),
                    SizedBox(width: 30),
                    // 제목, 저자, 출판연도 + 버튼
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              color: Color.fromARGB(255, 126, 113, 159),
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "저자 | ${widget.author}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 126, 113, 159),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 45),
                          Row(
                            children: [
                              Text(
                                "${widget.publisher} | ${widget.publishYear}년 ${widget.publishMonth}월",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB9AFD4),
                                  fontSize: 14,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.add_circle,
                                    color: Color.fromARGB(255, 126, 113, 159),
                                    size: 45),
                                onPressed: () {
                                  // + 버튼 동작
                                  print("책 추가 버튼 클릭");
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),

              // 상단 섹션 밑줄
              Divider(
                  color: Color.fromARGB(255, 126, 113, 159), thickness: 0.5),
              SizedBox(height: 16),

              // 시작일과 종료일
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "시작일                         ${widget.startDay.isNotEmpty ? widget.startDay : ' - '}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 126, 113, 159),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "종료일                         ${widget.endDay.isNotEmpty ? widget.endDay : ' - '}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 126, 113, 159),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // 세그먼트 바
              Container(
                margin:
                    EdgeInsets.symmetric(vertical: 16), // 세그먼트 바와 콘텐츠 사이 여백 추가
                decoration: BoxDecoration(
                  color: Colors.grey[200], // 탭 배경 색상 설정
                  borderRadius:
                      BorderRadius.circular(50), // 둥근 배경을 위한 borderRadius
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 각 탭을 Expanded로 감싸서 고정된 크기 설정
                    Expanded(
                      child: _buildSegment('상세정보', 0),
                    ),
                    Expanded(
                      child: _buildSegment('리뷰', 1),
                    ),
                  ],
                ),
              ),
              // 탭에 해당하는 내용
              _getTabContent(_currentTabIndex),
            ],
          ),
        ),
      ),
    );
  }

  // 세그먼트 탭을 만들기 위한 메소드
  Widget _buildSegment(String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
        margin: EdgeInsets.only(right: 5.0, left: 5.0, top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
          color: _currentTabIndex == index
              ? Colors.white
              : Colors.transparent, // 선택된 탭은 흰색 배경
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15, // 폰트 크기 설정
            color: _currentTabIndex == index
                ? Color.fromARGB(255, 70, 12, 230) // 선택된 탭은 색 변경
                : Colors.black,
          ),
          textAlign: TextAlign.center, // 텍스트가 중앙에 위치하도록 설정
        ),
      ),
    );
  }

  // 선택된 탭에 해당하는 콘텐츠를 반환하는 메소드
  Widget _getTabContent(int index) {
    switch (index) {
      case 0: // 상세정보 탭
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "${widget.description}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color.fromARGB(255, 126, 113, 159),
            ),
          ),
        );
      case 1: // 리뷰 탭
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildReviewList(),
        );
      default:
        return Center(child: Text("잘못된 탭입니다."));
    }
  }

  // 리뷰 목록을 보여주는 메소드
  Widget _buildReviewList() {
    if (reviews.isEmpty) {
      return Center(
        child: Text(
          "아직 작성된 리뷰가 없습니다.",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color.fromARGB(255, 126, 113, 159),
          ),
        ),
      );
    }

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
                // 프로필 사진, 닉네임, @id, 별점 입력 부분
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20, // 프로필 사진 크기 설정
                      backgroundImage:
                          AssetImage('image/DefaultProfile.png'), // 프로필 사진
                    ),
                    SizedBox(width: 10),
                    // 닉네임과 @id를 한 줄로 배치
                    Row(
                      children: [
                        Text(
                          '닉네임', // 여기서 닉네임을 동적으로 설정할 수 있습니다
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '@id', // 여기서 @id를 동적으로 설정할 수 있습니다
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    Spacer(),
                    // 별점 입력을 위한 RatingBar
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating); // 별점 선택 후 처리할 코드
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // 리뷰 텍스트 입력
                TextField(
                  decoration: InputDecoration(
                    hintText: "리뷰를 작성하세요...",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3, // 여러 줄 입력 가능
                ),
                SizedBox(height: 10),

                // '리뷰 등록' 버튼을 입력창 밖에 배치
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // 리뷰 등록 버튼 클릭 시 처리할 코드
                      print("리뷰 등록");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color.fromARGB(255, 126, 113, 159), // 버튼 색상
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
        ListView.builder(
          shrinkWrap: true, // ListView가 ScrollView 내에서 작동하도록 설정
          physics: NeverScrollableScrollPhysics(), // 외부 ScrollView와 충돌 방지
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
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
