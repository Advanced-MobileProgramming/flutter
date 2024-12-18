import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:soobook/bookDetail.dart';
import 'package:soobook/bookSearch.dart';
import 'myHome.dart';
import 'bookShelf.dart';
import 'myPage.dart';

class AllBooksPage extends StatefulWidget {
  final String userId;
  final String nickname;
  final String? searchQuery; // 검색어를 받는 변수

  AllBooksPage(
      {required this.userId, required this.nickname, this.searchQuery});

  @override
  _AllBooksPageState createState() => _AllBooksPageState();
}

class _AllBooksPageState extends State<AllBooksPage> {
  int _selectedIndex = 2;
  List<Map<String, dynamic>> books = [];
  bool isLoading = true;
  String searchQuery = ''; // 여기서는 초기 값만 설정해줍니다.

  @override
  void initState() {
    super.initState();
    // 검색어 초기화 (생성자에서 전달된 검색어 사용)
    searchQuery = widget.searchQuery ?? '';
    fetchBooks(); // Firebase에서 책 데이터 가져오기
  }

  // Firebase에서 책 데이터 가져오기
  Future<void> fetchBooks() async {
    final DatabaseReference booksRef = FirebaseDatabase.instance.ref("books");

    try {
      final snapshot = await booksRef.get();
      if (snapshot.exists) {
        // snapshot.value의 타입이 Map인 경우 처리
        if (snapshot.value is Map) {
          final data = (snapshot.value as Map).entries.map((entry) {
            return Map<String, dynamic>.from(entry.value as Map);
          }).toList();
          setState(() {
            books = data;
            isLoading = false;
          });
        }
        // snapshot.value의 타입이 List인 경우 처리
        else if (snapshot.value is List) {
          final data = (snapshot.value as List)
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList();
          setState(() {
            books = data;
            isLoading = false;
          });
        } else {
          setState(() {
            books = [];
            isLoading = false;
          });
        }
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

  // 바텀 네비게이션 탭 변경
  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomePage(userId: widget.userId, nickname: widget.nickname),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BookshelfPage(
            userId: widget.userId,
            nickname: widget.nickname,
          ),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AllBooksPage(userId: widget.userId, nickname: widget.nickname),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MyPage(userId: widget.userId, nickname: widget.nickname),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 검색어에 맞는 책을 필터링
    final filteredBooks = books.where((book) {
      final title = book["title"] ?? ''; // title이 null이면 빈 문자열로 대체
      final author = book["author"] ?? ''; // author가 null이면 빈 문자열로 대체
      return title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          author.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '전체 도서',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 126, 113, 159),
          ),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 120.0,
        automaticallyImplyLeading: false, // 뒤로 가기 버튼 비활성화
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: // 검색 바
            Container(
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
                      onChanged: (value) {
                        // 검색어 입력 시 검색어 업데이트
                        setState(() {
                          searchQuery = value;
                        });
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
          SizedBox(height: 16),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : filteredBooks.isEmpty
                  ? Center(child: Text('해당 도서가 존재하지 않습니다.'))
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: filteredBooks.length,
                          itemBuilder: (context, index) {
                            final book = filteredBooks[index];
                            final timestamp = book["publication_date"];
                            String publishYear = "0000";
                            String publishMonth = "00";

                            if (timestamp != null && timestamp is int) {
                              final date = DateTime.fromMillisecondsSinceEpoch(
                                  timestamp * 1000);
                              publishYear = date.year.toString();
                              publishMonth = date.month.toString().padLeft(2, '0');
                            }

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookDetail(
                                      userId: widget.userId,
                                      bookId: book["id"],
                                      nickname: widget.nickname,
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  book["image_path"] ?? "image/book_image_1.jpg",
                                  fit: BoxFit.cover,
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