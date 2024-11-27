import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:soobook/bookShelf.dart';
import 'package:soobook/myPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'myHome.dart'; // HomePage import 추가

class AllBooksPage extends StatefulWidget {
  @override
  _AllBooksPageState createState() => _AllBooksPageState();
}

class _AllBooksPageState extends State<AllBooksPage> {
  int _selectedIndex = 2;
  // 수정된 코드
  List<Map<String, dynamic>> books = []; // 도서 목록을 저장할 리스트
  String searchQuery = ''; // 검색어를 저장할 변수
  bool isLoading = true; // 데이터 로딩 여부를 저장할 변수

  Future<void> fetchBooks() async {
    final DatabaseReference booksRef = FirebaseDatabase.instance.ref("books");

    try {
      final DataSnapshot snapshot = await booksRef.get();
      if (snapshot.exists) {
        final data = snapshot.value as List<dynamic>;
        setState(() {
          books = data.map((book) => Map<String, dynamic>.from(book)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          books = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Firebase 데이터 가져오기 오류: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBooks(); // 도서 목록 데이터 가져오기
  }

  // 기존코드
  // final List<Map<String, String>> books = List.generate(
  //   10,
  //   (index) => {
  //     "title": "Book $index",
  //     "image": 'image/book_image_1.jpg', // 실제 책 이미지 경로로 변경
  //     "author": "Author $index", // 책 저자
  //     "description": "책에 대한 간단한 설명입니다.", // 책 설명
  //   },
  // );

  // final PageController _pageController =
  //     PageController(viewportFraction: 0.5); // viewportFraction을 0.5로 설정

  // String searchQuery = '';

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
          builder: (context) => HomePage(username: 'example'), // 사용자 이름 전달
        ),
      );
    } else if (index == 1) {
      // 책장 탭 클릭 시 BookShelfPage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookshelfPage()),
      );
    } else if (index == 2) {
      // 도서 탭 클릭 시 AllBooksPage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AllBooksPage()),
      );
    } else if (index == 3) {
      // 마이페이지 탭 클릭 시 MyPage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyPage()),
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
          backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 검색 바
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color.fromARGB(98, 187, 163, 187), // 채도가 낮은 보라색
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: '도서명이나 저자를 입력하세요.',
                        hintStyle: TextStyle(fontSize: 14),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.grey),
                    onPressed: () {
                      // 검색 버튼 클릭 시 동작 (현재는 입력값으로 자동 검색)
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16), // 검색 바와 리스트 간 간격

            // 도서 목록 표시
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
                  // 코드 추가
                  final book = filteredBooks[index];
                  final imagePath =
                      book["image_path"] ?? 'image/book_image_1.jpg';
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        imagePath,
                        //filteredBooks[index]["image"]!, // 동적으로 이미지 변경
                        fit: BoxFit.cover, // 이미지를 카드 크기에 맞게 채움
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
