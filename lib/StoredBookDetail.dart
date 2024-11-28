import 'package:flutter/material.dart';
import 'package:soobook/reviewList.dart';

class StoredBookDetail extends StatefulWidget {
  final String title;
  final String image;
  final String author;
  final String description;
  final String status;
  final String startDay;
  final String endDay;
  final String publisher;
  final int publishYear;
  final int publishMonth;
  final int totalPages;
  final int readPages;
  final String collection;
  final String review;
  final String bookReport;

  StoredBookDetail({
    required this.title,
    required this.image,
    required this.author,
    required this.description,
    required this.status,
    required this.startDay,
    required this.endDay,
    required this.publisher,
    required this.publishYear,
    required this.publishMonth,
    required this.totalPages,
    required this.readPages,
    required this.collection,
    required this.review,
    required this.bookReport,
  });

  @override
  _StoredBookDetailState createState() => _StoredBookDetailState();
}

class _StoredBookDetailState extends State<StoredBookDetail> {
  int _currentTabIndex = 0; // 세그먼트 바 초기값
  bool _isExpanded = false; // 텍스트가 부모를 초과했는지 여부

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
                                fontSize: 14),
                          ),
                          SizedBox(height: 60),
                          Row(
                            children: [
                              Text(
                                "${widget.publisher} | ${widget.publishYear}년 ${widget.publishMonth}월",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB9AFD4),
                                    fontSize: 14),
                              ),
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

              // 시작일과 종료일 및 독서량 표시
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    // 독서량 표시 (CircularProgressIndicator)
                    Column(
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // 크기 키우기
                              SizedBox(
                                width: 65, // 원의 너비
                                height: 65, // 원의 높이
                                child: CircularProgressIndicator(
                                  value: widget.totalPages > 0
                                      ? (widget.readPages / widget.totalPages)
                                          .clamp(0.0,
                                              1.0) // 진행률 계산valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 126, 113, 159)), // 진행 색상
                                      : 0.0, // 페이지 수가 0일 경우 0으로 설정
                                  backgroundColor: Color.fromARGB(
                                      255, 214, 208, 232), // 배경 색상
                                  strokeWidth: 5.0, // 원형 바의 두께 증가
                                ),
                              ),
                              Text(
                                "${widget.totalPages > 0 ? ((widget.readPages / widget.totalPages) * 100).clamp(0.0, 100.0).toInt() : 0}%", // 퍼센트를 텍스트로 표시
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 126, 113, 159),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        // 추가된 텍스트
                        Text(
                          "${widget.readPages}/${widget.totalPages}p",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 126, 113, 159),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),

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
                      child: _buildSegment('독후감', 1),
                    ),
                    Expanded(
                      child: _buildSegment('리뷰', 2),
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
                color: Color.fromARGB(255, 126, 113, 159)),
          ),
        );
      case 1: // 독후감 탭
        return Container(
          width: 600, // 고정된 가로 크기
          height: 330, // 고정된 세로 크기
          padding: const EdgeInsets.only(
            left: 22.0,
            right: 20.0,
            top: 50.0,
          ), // 안쪽 여백
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 226, 224, 231), // 배경색
            borderRadius: BorderRadius.circular(30), // 둥근 모서리
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                offset: Offset(4, 4),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.bookReport,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color.fromARGB(255, 126, 113, 159),
                ),
                overflow: _isExpanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis, // 확장된 경우... 없앰
                maxLines: _isExpanded ? null : 9, // 최대 9줄까지만 보이게 함
              ),
              if (!_isExpanded &&
                  widget.bookReport.length > 272) // 텍스트가 길면 + 더보기 버튼을 보여줌
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, // 버튼을 오른쪽으로 정렬
                  children: [
                    TextButton(
                      onPressed: () {
                        // 여기에서 아무 동작도 하지 않도록 남겨두기만 합니다.
                        print("더보기 버튼 클릭됨 "); // 현재는 아무 일도 일어나지 않음
                      },
                      child: Text(
                        "+ 더보기",
                        style: TextStyle(
                          color: Color.fromARGB(255, 126, 113, 159),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      case 2: // 리뷰 탭
        return Container(
          child: ReviewList(reviews: reviews), // ReviewList 위젯 호출
        );
      default:
        return Center(child: Text("잘못된 탭입니다."));
    }
  }
}
