import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  runApp(const BookSearchApp());
}

class BookSearchApp extends StatelessWidget {
  const BookSearchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BookSearchPage(userId: '',),
    );
  }
}

class BookSearchPage extends StatefulWidget {
  final String userId;
  //const BookSearchPage({Key? key}) : super(key: key);
  const BookSearchPage({Key? key, required this.userId}) : super(key: key);

  @override
  _BookSearchPageState createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  final FocusNode _focusNode = FocusNode(); // FocusNode 생성
  final TextEditingController _searchController = TextEditingController();
  String _searchResult = "";
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    // 화면 로딩 후 자동으로 포커스를 텍스트 필드로 맞춥니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode); // 포커스 주기
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // FocusNode를 사용한 후에는 반드시 dispose해야 합니다.
    _searchController.dispose(); // TextEditingController 정리
    super.dispose();
  }

  Future<void> searchBooks(String query) async { // 검색 미완성
    setState(() {
      _isLoading = true;
      _searchResult = "";
    });

try {
  // 1. bookcases에서 검색
  final DatabaseReference bookcasesRef =
      FirebaseDatabase.instance.ref("bookcases/${widget.userId}");
  final bookcasesSnapshot = await bookcasesRef.get();

  if (bookcasesSnapshot.exists) {
  print("bookcases 테이블에서 데이터 조회 성공: ${bookcasesSnapshot.value}");
  final booksInBookcases = Map<String, dynamic>.from(
      bookcasesSnapshot.value as Map<dynamic, dynamic>);
  for (var book in booksInBookcases.values) {
    print("bookcases의 책 데이터: $book"); // 추가 로그
    if (book['title']?.contains(query) == true ||
        book['author']?.contains(query) == true) {
      print("Found in bookcases: ${book['title']} by ${book['author']}"); // 로그 추가
      setState(() {
        _searchResult =
            "Found in Bookcases:\n${book['title']} by ${book['author']}";
        _isLoading = false;
      });
      return; // bookcases에서 찾으면 종료
    }
  }
}


  // 2. books에서 검색
  final DatabaseReference booksRef = FirebaseDatabase.instance.ref("books");
  final booksSnapshot = await booksRef.get();

  if (booksSnapshot.exists) {
  print("books 테이블에서 데이터 조회 성공: ${booksSnapshot.value}");
  final allBooks = Map<String, dynamic>.from(
      booksSnapshot.value as Map<dynamic, dynamic>);
  for (var book in allBooks.values) {
    print("books의 책 데이터: $book"); // 추가 로그
    if (book['title']?.contains(query) == true ||
        book['author']?.contains(query) == true) {
      print("Found in books: ${book['title']} by ${book['author']}"); // 로그 추가
      setState(() {
        _searchResult =
            "Found in Books:\n${book['title']} by ${book['author']}";
        _isLoading = false;
      });
      return; // books에서 찾으면 종료
    }
  }
}


  // 결과 없음
  print("No results found in both bookcases and books."); // 로그 추가
  setState(() {
    _searchResult = "No results found.";
    _isLoading = false;
  });
} catch (e) {
  print("Error during search: $e"); // 에러 로그 추가
  setState(() {
    _searchResult = "Error: $e";
    _isLoading = false;
  });
}

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('책 검색',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 126, 113, 159))),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // 뒤로 가기 버튼 비활성화
        toolbarHeight: 120.0, // AppBar 높이를 조정하여 더 많은 패딩 추가
        titleSpacing: 20.0, // 타이틀과 왼쪽 모서리 사이의 간격을 늘림
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Color.fromARGB(255, 126, 113, 159)),
          onPressed: () {
            // 뒤로 가기 동작 정의
            _searchController.clear();
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: InkWell(
              onTap: () {
                // 검색 페이지로 이동 (userId 유지)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BookSearchPage(userId: widget.userId),
                  ),
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
                        focusNode: _focusNode, // TextField에 focusNode 지정
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
                          // 텍스트 필드 클릭 시 다른 동작을 할 수 있습니다.
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: Color.fromARGB(255, 109, 109, 109)),
  onPressed: () {
    if (_searchController.text.isNotEmpty) {
      searchBooks(_searchController.text.trim());
    } else {
      setState(() {
        _searchResult = "Please enter a search query.";
      });
    }
  },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}