import 'package:flutter/material.dart';
import 'package:soobook/bookShelf.dart';
import 'package:soobook/myPage.dart';
import 'myHome.dart';
import 'bookSearch.dart';
import 'UnstoredBookDetail.dart';

class AllBooksPage extends StatefulWidget {
  final String username;
  AllBooksPage({required this.username});
  @override
  _AllBooksPageState createState() => _AllBooksPageState();
}

class _AllBooksPageState extends State<AllBooksPage> {
  int _selectedIndex = 2;
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

  final PageController _pageController =
      PageController(viewportFraction: 0.5); // viewportFraction을 0.5로 설정

  String searchQuery = '';

  // 탭을 눌렀을 때 페이지 변경
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // 홈 탭 클릭 시 HomePage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(username: widget.username), // 사용자 이름 전달
        ),
      );
    } else if (index == 1) {
      // 책장 탭 클릭 시 BookShelfPage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookshelfPage(username: widget.username)),
      );
    } else if (index == 2) {
      // 도서 탭 클릭 시 AllBooksPage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AllBooksPage(username: widget.username)),
      );
    } else if (index == 3) {
      // 마이페이지 탭 클릭 시 MyPage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyPage(username: widget.username)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 검색 결과에 맞게 필터링된 책 목록
    final filteredBooks = books.where((book) {
      return book["title"]!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          book["author"]!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('전체 도서',
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
          SizedBox(height: 16),
          // 도서 목록 표시
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0), // 외부와의 패딩 값 (위, 아래, 좌, 우 16.0)
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
                      // 예: 상세 정보 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UnstoredBookDetail(
                            title: filteredBooks[index]["title"]!,
                            image: filteredBooks[index]["image"]!,
                            author: filteredBooks[index]["author"]!,
                            description: filteredBooks[index]["description"]!,
                            status: filteredBooks[index]["status"]!,
                            progress: filteredBooks[index]["progress"]!,
                            startDay: '',
                            endDay: '',
                            publisher: '한빛미디어',
                            publishYear: '2023',
                            publishMonth: '3',
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
}
