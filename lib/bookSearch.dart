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

class BookSearchPage extends StatelessWidget {
  const BookSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '책 검색',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 126, 113, 159),
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // 기본 뒤로가기 버튼 비활성화
        toolbarHeight: 120.0, // AppBar 높이 조정
        titleSpacing: 20.0, // 타이틀과 왼쪽 모서리 간격 조정
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 126, 113, 159)),
          onPressed: () {
            // 뒤로 가기 동작 정의
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // 검색 바
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        // 페이지 이동 동작을 제거했습니다. 필요시 여기에 다른 동작을 넣을 수 있습니다.
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Color.fromARGB(255, 109, 109, 109)),
                    onPressed: () {
                      // 검색 버튼 클릭 시 동작을 여기에서 처리합니다.
                      // 예: 입력된 검색어를 사용하여 검색 동작을 수행
                    },
                  ),
                ],
              ),
            ),
          )
          ],
        ),
      ),
    );
  }
}