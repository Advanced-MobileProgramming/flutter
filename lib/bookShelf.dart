import 'dart:math';
import 'package:flutter/material.dart';
import 'allBooks.dart';
import 'myPage.dart';
import 'myHome.dart';
import 'bookSearch.dart';
import 'StoredBookDetail.dart';

class BookshelfPage extends StatefulWidget {
  final String username;
  BookshelfPage({required this.username});
  @override
  _BookshelfPageState createState() => _BookshelfPageState();
}

class _BookshelfPageState extends State<BookshelfPage> {
  int _selectedIndex = 1;
  int _currentTabIndex = 0; // 현재 선택된 탭을 추적하는 변수

  final PageController _pageController = PageController(viewportFraction: 1.0);

  // 책 리스트
  final List<Map<String, dynamic>> books = List.generate(
  10,
  (index) => {
    "title": "Book $index",
    "image": 'image/book_image_${index + 1}.jpg', // 실제 책 이미지 경로로 변경
    "author": "Author $index", // 책 저자
    "description": "책에 대한 간단한 설명입니다.", // 책 설명
    "status": 
        index % 2 == 0
        ? "reading"  // 읽는 중
        : "completed", // 완료
    "progress": index % 2 == 0 ? 0.3 * (index + 1) % 1 : 1.0, // 읽기 진행 상태
  },);

  String searchQuery = '';

  // 탭을 눌렀을 때 페이지 변경
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(username: widget.username)),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BookshelfPage(username: widget.username,)),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AllBooksPage(username: widget.username)),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyPage(username: widget.username,)),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.username}의 책장',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 126, 113, 159))),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // 뒤로 가기 버튼 비활성화
        toolbarHeight: 120.0, // AppBar 높이를 조정하여 더 많은 패딩 추가
        titleSpacing: 20.0, // 타이틀과 왼쪽 모서리 사이의 간격을 늘림
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: InkWell(
              onTap: () {
                // 검색 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookSearchPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(98, 187, 163, 187), // 채도가 낮은 보라색
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '도서명이나 저자를 입력하세요.',
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 109, 109, 109),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 패딩 설정
                        ),
                        onTap: () {
                          // 검색 바를 탭하면 페이지로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BookSearchPage()),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Color.fromARGB(255, 109, 109, 109)),
                      onPressed: () {
                        // 추가적인 검색 동작 처리 가능
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 세그먼트 컨트롤 바
          Padding(padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Container(
            margin: EdgeInsets.only(top: 16.0), // 세그먼트 바와 콘텐츠 사이 여백 추가
            decoration: BoxDecoration(
              color: Colors.grey[200], // 탭 배경 색상 설정
              borderRadius: BorderRadius.circular(50), // 둥근 배경을 위한 borderRadius
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 각 탭을 Expanded로 감싸서 고정된 크기 설정
                Expanded(
                  child: _buildSegment('전체', 0),
                ),
                Expanded(
                  child: _buildSegment('읽는중', 1),
                ),
                Expanded(
                  child: _buildSegment('완료', 2),
                ),
                Expanded(
                  child: _buildSegment('컬렉션', 3),
                ),
              ],
            ),
          ),
          ),
          // 탭에 해당하는 내용
          Expanded(
            child: _getTabContent(_currentTabIndex),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
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

  // 세그먼트 탭을 만들기 위한 메소드
  Widget _buildSegment(String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
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
            fontSize: 14, // 폰트 크기 설정
            color: _currentTabIndex == index
              ? Color.fromARGB(255, 70, 12, 230) // 선택된 탭은 색 변경
              : Colors.black,
          ),
          textAlign: TextAlign.center, // 텍스트가 중앙에 위치하도록 설정
        ),
      ),
    );
  }

  // 탭에 맞는 책 목록을 필터링하여 반환하는 메소드
  List<Map<String, dynamic>> getFilteredBooks(String status) {
    if (status == "reading") {
      // 읽는 중(reading)
      return books.where((book) => book["status"] == "reading").toList();
    } else if (status == "completed") {
      // 완료 (completed)
      return books.where((book) => book["status"] == "completed").toList();
    } 
    // 전체 목록(all)
    return books;
  }

  // 선택된 탭에 해당하는 콘텐츠를 반환하는 메소드
  Widget _getTabContent(int index) {
    switch (index) {
      case 0: // 전체
        final filteredBooks = getFilteredBooks("all");
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0, right: 16.0, left: 16.0),
          child: Column(
            children: [
              // 편집 텍스트 버튼
              Align(
                alignment: Alignment.topRight,  // 오른쪽 상단에 버튼을 배치
                child: TextButton(
                  onPressed: () {
                  },
                  child: Text(
                    "편집",  // 텍스트 버튼의 내용
                    style: TextStyle(
                      color: Color.fromARGB(255, 126, 113, 159),  // 버튼 텍스트 색상
                      decoration: TextDecoration.underline
                    ),
                  ),
                ),
              ),
              // 그리드 뷰
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(0), // 외부와의 패딩 값
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3개의 열
                      crossAxisSpacing: 8, // 열 간 간격
                      mainAxisSpacing: 8, // 행 간 간격
                      childAspectRatio: 0.7, // 아이템의 가로 세로 비율 (이미지 크기 조정)
                    ),
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // 카드를 눌렀을 때 동작
                          print('${filteredBooks[index]["title"]} 카드가 클릭되었습니다.');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoredBookDetail(
                                title: filteredBooks[index]["title"]!,
                                image: filteredBooks[index]["image"]!,
                                author: filteredBooks[index]["author"]!,
                                description: filteredBooks[index]["description"]!,
                                status: filteredBooks[index]["status"]!,
                                progress: filteredBooks[index]["progress"]!,
                                startDay: '2024.10.08', // 임시 데이터 전송
                                endDay: '2024.10.08',
                                publisher: '한빛미디어',
                                publishYear: '2023',
                                publishMonth: '3',
                                totalPages: 736,
                                readPages: 220,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              filteredBooks[index]["image"]!, // 동적으로 이미지 변경
                              fit: BoxFit.cover, // 이미지를 카드 크기에 맞게 채움
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      case 1: // 읽는 중
        final filteredBooks = getFilteredBooks("reading");
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0, right: 16.0, left: 16.0), // 외부 여백
          child: Stack(
            children: [
              // GridView (카드 리스트)
              Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 한 행에 3개의 카드
                    crossAxisSpacing: 8, // 열 간격
                    mainAxisSpacing: 20, // 행 간격
                    childAspectRatio: 0.65, // 카드와 퍼센트 바 포함 비율
                  ),
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Expanded(
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                filteredBooks[index]["image"]!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 13.0),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10), // 둥근 끝을 위한 반경 설정
                            child: SizedBox(
                              width: 110, // 바의 길이 설정
                              //height: 10, // 바의 높이 설정
                              child: LinearProgressIndicator(
                                value: filteredBooks[index]["progress"], // 진행 상태 (0.0 ~ 1.0)
                                backgroundColor: Colors.grey[200], // 배경색
                                valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 126, 113, 200)), // 진행 색상
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // 편집 버튼
              Align(
                alignment: Alignment.topRight, // 오른쪽 상단에 고정
                child: TextButton(
                  onPressed: () {
                    // 버튼 동작 정의
                  },
                  child: Text(
                    "편집",
                    style: TextStyle(
                      color: Color.fromARGB(255, 126, 113, 159),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      case 2: // 완료
        final filteredBooks = getFilteredBooks("completed");
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0, right: 16.0, left: 16.0),
          child: Column(
            children: [
              // 편집 텍스트 버튼
              Align(
                alignment: Alignment.topRight,  // 오른쪽 상단에 버튼을 배치
                child: TextButton(
                  onPressed: () {
                  },
                  child: Text(
                    "편집",  // 텍스트 버튼의 내용
                    style: TextStyle(
                      color: Color.fromARGB(255, 126, 113, 159),  // 버튼 텍스트 색상
                      decoration: TextDecoration.underline
                    ),
                  ),
                ),
              ),
              // 그리드 뷰
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3개의 열
                    crossAxisSpacing: 8, // 열 간 간격
                    mainAxisSpacing: 8, // 행 간 간격
                    childAspectRatio: 0.7, // 아이템의 가로 세로 비율 (이미지 크기 조정)
                  ),
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          filteredBooks[index]["image"]!, // 동적으로 이미지 변경
                          fit: BoxFit.cover, // 이미지를 카드 크기에 맞게 채움
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      case 3: // 컬렉션
      // 컬렉션 목록 (임시 데이터)
        final collections = [
          "인생책",
          "시집",
          "에세이",
          "소설",
        ];
        return Padding(
          padding: const EdgeInsets.all(16.0), // 외부 여백 추가
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 한 행에 2개의 카드
              crossAxisSpacing: 16, // 열 간 간격
              mainAxisSpacing: 23, // 행 간 간격
              childAspectRatio: 1, // 카드의 가로 세로 비율
            ),
            itemCount: collections.length + 1, // 첫 번째 카드(+) 포함하여 개수 설정
            itemBuilder: (context, index) {
              if (index == 0) {
                // 첫 번째 카드 - 컬렉션 추가
                return GestureDetector(
                  onTap: () {
                    print("'+' card clicked");
                  },
                  child: Card(
                    elevation: 4,
                    color: const Color.fromARGB(235, 232, 224, 232),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          print("'+' button clicked");
                        },
                        icon: Icon(
                          Icons.add, // '+' 아이콘
                          color: Color.fromARGB(255, 126, 113, 159),
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                // 컬렉션 카드
                return GestureDetector(
                  onTap: () {
                    print("${collections[index - 1]} card clicked");
                  },
                  child: Card(
                    elevation: 4,
                    color: const Color.fromARGB(235, 232, 224, 232),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        // 텍스트를 원하는 위치에 배치
                        Positioned(
                          top: 50, // 텍스트의 상단 위치
                          left: 45, // 텍스트의 왼쪽 위치
                          child: Text(
                            collections[index - 1],
                            style: const TextStyle(
                              fontSize: 23,
                              color: Color.fromARGB(255, 126, 113, 159),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // 오른쪽 상단에 설정 아이콘 추가
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              print("Settings icon clicked");
                            },
                            child: IconButton(
                            onPressed: () {
                              print("Settings icon button clicked");
                            },
                            icon: Icon(
                              Icons.more_vert, // 점 세개 아이콘
                              color: Color.fromARGB(255, 126, 113, 159),
                              size: 30,
                            ),
                          ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        );
      default:
        return Center(child: Text("전체 책들 목록"));
    }
  }
}