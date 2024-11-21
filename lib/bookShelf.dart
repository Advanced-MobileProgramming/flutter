import 'package:flutter/material.dart';
import 'allBooks.dart';
import 'myPage.dart';
import 'myHome.dart';
import 'bookSearch.dart';

class BookshelfPage extends StatefulWidget {
  @override
  _BookshelfPageState createState() => _BookshelfPageState();
}

class _BookshelfPageState extends State<BookshelfPage> {
  int _selectedIndex = 1;
  int _currentTabIndex = 0; // 현재 선택된 탭을 추적하는 변수

  final PageController _pageController = PageController(viewportFraction: 1.0);

  // 탭을 눌렀을 때 페이지 변경
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(username: 'username')),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BookshelfPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AllBooksPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyPage()),
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
        title: Text('책장',
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
                  MaterialPageRoute(
                      builder: (context) => const BookSearchPage()),
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
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8), // 패딩 설정
                        ),
                        onTap: () {
                          // 검색 바를 탭하면 페이지로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BookSearchPage()),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search,
                          color: Color.fromARGB(255, 109, 109, 109)),
                      onPressed: () {
                        // 추가적인 검색 동작 처리 가능
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 세그먼트 컨트롤 바 (네모 박스 형식)
          Container(
            margin: EdgeInsets.symmetric(vertical: 16), // 세그먼트 바와 콘텐츠 사이 여백 추가
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSegment('전체', 0),
                    _buildSegment('읽는 중', 1),
                    _buildSegment('완료', 2),
                    _buildSegment('컬렉션', 3),
                  ],
                ),
                // 세그먼트 바 아래에 보더라인 추가
                Container(
                  height: 0.7,
                  color: Color.fromARGB(255, 126, 113, 159), // 보라색 보더라인
                  margin: EdgeInsets.only(top: 8),
                ),
              ],
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
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        margin: EdgeInsets.only(right: 16, left: 16),
        decoration: BoxDecoration(
          color: _currentTabIndex == index
              ? Color.fromARGB(255, 126, 113, 159)
              : Colors.transparent, // 선택된 탭은 보라색 배경
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12, // 폰트 크기 설정
            color: _currentTabIndex == index
                ? Colors.white
                : Color.fromARGB(255, 126, 113, 159),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 선택된 탭에 해당하는 콘텐츠를 반환하는 메소드
  Widget _getTabContent(int index) {
    switch (index) {
      case 0:
        return Center(child: Text("전체 책들 목록"));
      case 1:
        return Center(child: Text("읽는 중 목록"));
      case 2:
        return Center(child: Text("완료 목록"));
      case 3:
        return Center(child: Text("컬렉션 목록"));
      default:
        return Center(child: Text("전체 책들 목록"));
    }
  }
}
