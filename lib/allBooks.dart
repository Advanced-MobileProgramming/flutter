import 'package:firebase_database/firebase_database.dart';
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
  // 수정된 코드
  List<Map<String, dynamic>> books = [];
  bool isLoading = true;
  String searchQuery = '';

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
    fetchBooks(); // 책 데이터 가져오기
  }

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
          builder: (context) =>
              HomePage(username: widget.username), // 사용자 이름 전달
        ),
      );
    } else if (index == 1) {
      // 책장 탭 클릭 시 BookShelfPage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BookshelfPage(username: widget.username)),
      );
    } else if (index == 2) {
      // 도서 탭 클릭 시 AllBooksPage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AllBooksPage(username: widget.username)),
      );
    } else if (index == 3) {
      // 마이페이지 탭 클릭 시 MyPage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyPage(username: widget.username)),
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
          SizedBox(height: 16),
          // 도서 목록 표시
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.all(16.0), // 외부와의 패딩 값 (위, 아래, 좌, 우 16.0)
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3개의 열
                  crossAxisSpacing: 12, // 열 간 간격
                  mainAxisSpacing: 16, // 행 간 간격
                  childAspectRatio: 0.7, // 아이템의 가로 세로 비율 (이미지 크기 조정)
                ),
                itemCount: filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = filteredBooks[index]; // 추가
                  return GestureDetector(
                    onTap: () {
                      // 카드를 눌렀을 때 동작
                      print('${filteredBooks[index]["title"]} 카드가 클릭되었습니다.');
                      // 예: 상세 정보 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            final timestamp = book["publication_date"];
                            String publishYear = "0000";
                            String publishMonth = "00";

                            if (timestamp != null && timestamp is int) {
                              final date = DateTime.fromMillisecondsSinceEpoch(
                                  timestamp * 1000);
                              publishYear = date.year.toString();
                              publishMonth =
                                  date.month.toString().padLeft(2, '0');
                            }

                            return UnstoredBookDetail(
                              title: book["title"] ?? "제목 없음",
                              image: book["image_path"] ??
                                  "image/book_image_1.jpg",
                              author: book["author"] ?? "저자 없음",
                              description: book["description"] ?? "설명 없음",
                              publisher: book["publisher"] ?? "출판사 없음",
                              publishYear: publishYear,
                              publishMonth: publishMonth,
                            );
                          },
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10), // 모서리를 둥글게
                      child: Image.asset(
                        book["image_path"] ??
                            "image/book_image_1.jpg", // 이미지 경로
                        fit: BoxFit.cover, // 이미지가 영역을 꽉 채우도록 설정
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          );
                        },
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
