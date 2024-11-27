import 'package:flutter/material.dart';

void main() {
  runApp(const BookSearchApp());
}

class BookSearchApp extends StatelessWidget {
  const BookSearchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BookSearchPage(),
    );
  }
}

class BookSearchPage extends StatefulWidget {
  const BookSearchPage({Key? key}) : super(key: key);

  @override
  _BookSearchPageState createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  final FocusNode _focusNode = FocusNode(); // FocusNode 생성

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
    super.dispose();
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
        ],
      ),
    );
  }
}
