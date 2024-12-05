import 'package:flutter/material.dart';
import 'package:soobook/bookShelf.dart';
import 'package:soobook/myPage.dart';
import 'allBooks.dart';
import 'bookSearch.dart';
import 'myReview.dart';

class HomePage extends StatefulWidget {
  final String userId;
  final String nickname;

  HomePage({required this.userId, required this.nickname});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.5);
  final TextEditingController _searchController = TextEditingController();

  // 책 리스트
  final List<Map<String, dynamic>> books = List.generate(
    10,
    (index) => {
      "title": "Book $index",
      "image": 'image/book_image_${index + 1}.jpg', // 실제 책 이미지 경로로 변경
      "author": "Author $index", // 책 저자
      "description": "책에 대한 간단한 설명입니다.", // 책 설명
      "status": index % 2 == 0 ? "reading" : "completed", // 읽는 중/완료
      "progress": index % 2 == 0 ? 0.3 * (index + 1) % 1 : 1.0, // 읽기 진행 상태
    },
  );

  List<Map<String, dynamic>> reviews = [
    {
      "book_title": "book title",
      "book_image": 'image/book_image_1.jpg', // 임시 이미지 경로
      "review": "이 책은 Flutter에 대한 기본 개념을 쉽게 설명해 줍니다. 추천합니다!",
    }
  ];

  // 탭을 눌렀을 때 페이지 변경
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      // 책장 탭 클릭 시 BookShelfPage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BookshelfPage(
                userId: widget.userId, nickname: widget.nickname)),
      );
    } else if (index == 2) {
      // 도서 탭 클릭 시 AllBooksPage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AllBooksPage(userId: widget.userId, nickname: widget.nickname)),
      );
    } else if (index == 3) {
      // 마이페이지 탭 클릭 시 MyPage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MyPage(userId: widget.userId, nickname: widget.nickname)),
      );
    }
    _pageController.jumpToPage(index); // 애니메이션 없이 페이지 전환
  }

  // 검색창에서 입력한 텍스트로 AllBooksPage로 이동
  void _searchBooks() {
    String searchQuery = _searchController.text;

    if (searchQuery.isNotEmpty) {
      // 검색어가 있으면 AllBooksPage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllBooksPage(
            userId: widget.userId,
            nickname: widget.nickname,
            searchQuery: searchQuery, // 검색어 전달
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 홈 텍스트와 로고 배치
              Padding(
                padding:
                    const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('홈',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 126, 113, 159))),
                    Image.asset('image/logo2.png', width: 80, height: 80),
                  ],
                ),
              ),
              SizedBox(height: 20),
              //검색 바
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color:
                        const Color.fromARGB(98, 187, 163, 187), // 채도가 낮은 보라색
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: '도서명이나 저자를 입력하세요.',
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 109, 109, 109),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8), // 패딩 설정
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search,
                            color: Color.fromARGB(255, 109, 109, 109)),
                        onPressed: _searchBooks, // 검색 버튼 클릭 시 _searchBooks 호출
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // 인사말
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  '${widget.nickname}님, 안녕하세요:D\n오늘도 수Book한 하루 되세요!',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 126, 113, 159)),
                ),
              ),
              SizedBox(height: 20),
              // 오늘의 선택 섹션
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color.fromARGB(90, 94, 70, 120) // 채도가 낮은 보라색
                  ,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '이런 책은 어떠세요?',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 126, 113, 159),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 300,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          return AnimatedBuilder(
                            animation: _pageController,
                            builder: (context, child) {
                              // 현재 스크롤 위치
                              double value = 1.0;
                              if (_pageController.position.haveDimensions) {
                                value = _pageController.page! - index;
                                value = (1 - (value.abs() * 0.3))
                                    .clamp(0.7, 1.0); // 크기 조정
                              }
                              return Center(
                                child: SizedBox(
                                  height: Curves.easeOut.transform(value) * 250,
                                  width: Curves.easeOut.transform(value) * 200,
                                  child: child,
                                ),
                              );
                            },
                            child: Card(
                              elevation: 0,
                              //color: Colors.purple[50],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    books[index]["image"]!, // 동적으로 이미지 변경
                                    height: Curves.easeOut.transform(1.0) *
                                        150, // 기본 이미지 크기
                                    width: Curves.easeOut.transform(1.0) *
                                        150, // 기본 이미지 크기
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    books[index]["title"]!, // 동적으로 제목 변경
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // 내가 쓴 리뷰 섹션
              Text(
                '   내가 쓴 리뷰',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 126, 113, 159),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color.fromARGB(255, 221, 218, 226),
                ),
                child: reviews.isEmpty
                    ? SizedBox(
                        height: 150,
                        child: Center(
                          child: Text(
                            '리뷰가 없습니다.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    : Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 책 이미지 - 왼쪽에 배치, 크기 조정
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  reviews[0]["book_image"], // 첫 번째 리뷰 이미지
                                  width: 120,
                                  height: 180,
                                  fit: BoxFit.cover, // 이미지 잘리지 않도록 설정
                                ),
                              ),
                              SizedBox(width: 16), // 이미지와 텍스트 사이 간격
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 제목과 더보기 버튼
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            reviews[0]["book_title"], // 첫 번째 리뷰 제목
                                            style: TextStyle(
                                              color:  Color.fromARGB(255, 126, 113, 159),
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis, // 제목이 길 경우 생략
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // MyReviewPage로 이동
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => MyReviewPage(userId: widget.userId),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "더보기",
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 126, 113, 159),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    // 리뷰 내용
                                    Text(
                                      "❝${reviews[0]["review"]}❞",
                                      maxLines: 3, // 리뷰를 최대 3줄로 제한
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open),
            label: '책장',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: '도서',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '마이페이지',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }
}
