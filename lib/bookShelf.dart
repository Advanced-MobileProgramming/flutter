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
    "startDay": '2024.10.08',
    "endDay": '2024.10.08',
    "publisher": "한빛미디어",
    "publishYear": "2023",
    "publishMonth": "3",
    "totalPages": 736,
    "readPages": 220,
    "collection": "인생책",
    "review": "",
    "bookReport": "이 책은 일본의 유명 투자자이자 경제 평론가인 세이노 다카시가 자신의 경험과 지식을 바탕으로 작성한 책이다. 책은 저자의 어린 시절부터 시작해, 어떻게 경제적 자유를 얻었는지, 그리고 그 과정에서 얻은 중요한 삶의 교훈을 담고 있다.  그의 솔직한 이야기가 인상적인 부분이었다. 다음번에도 이 저자의 책이 나오면 구매해야겠다고 생각했다. 굿굿!~~~~~~🤓이 책은 일본의 유명 투자자이자 경제 평론가인 세이노 다카시가 자신의 경험과 지식을 바탕으로 작성한 책이다. 책은 저자의 어린Kkkk",
    "rating": 4,
    "isStored": true,
  },);

  String searchQuery = '';

  // 컬렉션 목록 (임시 데이터)
  final collections = [
    "인생책",
    "시집",
    "에세이",
    "소설",
  ];

  String? _selectedCollection; // 선택된 컬렉션 이름
  bool _enterCollection = false;

  // 현재 선택된 컬렉션에 담긴 책 리스트 반환
  List<Map<String, dynamic>> getFilteredCollectionBooks() {
    return books.where((book) => book["collection"] == _selectedCollection).toList();
  }

  // 컬렉션 추가 함수
  void addCollection(String collectionName) {
    setState(() {
      collections.add(collectionName);
    });
  }

  // 탭을 눌렀을 때 페이지 변경
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(username: widget.username)),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BookshelfPage(
                  username: widget.username,
                )),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AllBooksPage(username: widget.username)),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyPage(
                  username: widget.username,
                )),
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

  // 컬렉션 추가 다이얼로그를 띄우는 함수
  void showAddCollectionDialog(BuildContext context, Function(String) onAddCollection) {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '새 컬렉션 추가',
            style: TextStyle(
              color: Color.fromARGB(255, 126, 113, 159),
            ),
          ),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: '컬렉션 이름',
              labelStyle: TextStyle(
                color: Color.fromARGB(255, 126, 113, 159), // 라벨 텍스트 색상
              ),
            ),
            style: TextStyle(
              color: Color.fromARGB(255, 109, 109, 109), // 입력 텍스트 색상
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // 취소 버튼 클릭 시 다이얼로그 닫기
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 126, 113, 159),
                foregroundColor: Colors.white,
              ),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                // 추가 버튼 클릭 시 컬렉션 추가 로직
                String newCollection = _controller.text;
                if (newCollection.isEmpty) {
                  // 이름이 비어 있는 경우 경고 메시지 출력
                  Navigator.of(context).pop();
                  showMessageDialog(context, '이름을 입력해주세요.');
                } else if (collections.contains(newCollection)) {
                  // 이름이 중복된 경우 경고 메시지 출력
                  Navigator.of(context).pop();
                  showMessageDialog(context, '이미 존재하는 이름입니다.');
                } else {
                  // 새로운 컬렉션 추가
                  onAddCollection(newCollection);
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 126, 113, 159),
                foregroundColor: Colors.white,
              ),
              child: Text('추가'),
            ),
          ],
        );
      },
    );
  }

  // 컬렉션 수정/삭제 다이얼로그를 띄우는 함수
  void _showEditCollectionDialog(BuildContext context, int index) {
    TextEditingController _collectionNameController = TextEditingController();
    _collectionNameController.text = collections[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '컬렉션 수정',
            style: TextStyle(
              color: Color.fromARGB(255, 126, 113, 159),
            ),
          ),
          content: TextField(
            controller: _collectionNameController,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: '컬렉션 이름',
              labelStyle: TextStyle(
                color: Color.fromARGB(255, 126, 113, 159), // 라벨 텍스트 색상
              ),
            ),
            style: TextStyle(
              color: Color.fromARGB(255, 109, 109, 109), // 입력 텍스트 색상
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 취소
              },
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 126, 113, 159),
                foregroundColor: Colors.white,
              ),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                String newCollectionName = _collectionNameController.text.trim();

                // 중복 확인 로직 추가
                if (newCollectionName.isEmpty) {
                  showMessageDialog(context, "이름을 입력해주세요.");
                } else if (collections.contains(newCollectionName) && newCollectionName != collections[index]) {
                  showMessageDialog(context, "이미 존재하는 이름입니다.");
                } else {
                  setState(() {
                    // 수정된 컬렉션 이름 저장
                    collections[index] = newCollectionName;
                  });
                  Navigator.pop(context); // 수정 완료 후 다이얼로그 닫기
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 126, 113, 159),
                foregroundColor: Colors.white,
              ),
              child: Text('수정'),
            ),
            TextButton(
              onPressed: () {
                // 삭제 확인 다이얼로그 호출
                showConfirmDialog(
                  context,
                  title: "컬렉션 삭제",
                  message: "이 컬렉션을 삭제하시겠습니까?",
                  onConfirm: () {
                    setState(() {
                      // 컬렉션 삭제 로직
                      collections.removeAt(index);
                    });
                    Navigator.pop(context);
                  },
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 126, 113, 159),
                foregroundColor: Colors.white,
              ),
              child: Text('삭제'),
            )
          ],
        );
      },
    );
  }

  // 단순 확인 메세지 다이얼로그를 띄우는 함수
  void showMessageDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 100,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 세로 중심 정렬
            crossAxisAlignment: CrossAxisAlignment.center, // 가로 중심 정렬
            children: [
              SizedBox(height: 10.0,),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 109, 109, 109),
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 13), // 버튼과 메시지 간 간격
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 126, 113, 159), // 배경색
                  foregroundColor: Colors.white, // 글자색
                ),
                child: Text('확인'),
              ),
            ],
          ),
        ),
        );
      },
    );
  }

  // 다시 확인하는 다이얼로그를 띄우는 함수
  void showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm, // 확인 시 실행할 콜백 함수
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color: Color.fromARGB(255, 126, 113, 159),
              fontSize: 20,
            ),
          ),
          content: SizedBox(
            height: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 세로 정렬
              crossAxisAlignment: CrossAxisAlignment.center, // 가로 정렬
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 109, 109, 109),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기 (취소)
              },
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 126, 113, 159), // 버튼 배경색
                foregroundColor: Colors.white, // 글자색
              ),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
                onConfirm(); // 확인 시 콜백 호출
              },
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 126, 113, 159), // 버튼 배경색
                foregroundColor: Colors.white, // 글자색
              ),
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  // 컬렉션 이름 출력 조정히는 함수
  String formatCollectionName(String name) {
    // 이름이 6글자 초과 시 뒤에 "..." 추가
    if (name.length > 6) {
      return '${name.substring(0, 4)}\n${name.substring(4, 6)}...';
    } else if (name.length > 4) {
      // 이름이 4글자 초과 6글자 이하일 경우 줄바꿈 추가
      return '${name.substring(0, 4)}\n${name.substring(4)}';
    } else {
      // 이름이 4글자 이하일 경우 그대로 출력
      return name;
    }
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
          // 세그먼트 컨트롤 바
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Container(
              margin: EdgeInsets.only(top: 16.0), // 세그먼트 바와 콘텐츠 사이 여백 추가
              decoration: BoxDecoration(
                color: Colors.grey[200], // 탭 배경 색상 설정
                borderRadius:
                    BorderRadius.circular(50), // 둥근 배경을 위한 borderRadius
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
          _enterCollection = false;
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
                alignment: Alignment.topRight, // 오른쪽 상단에 버튼을 배치
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "편집", // 텍스트 버튼의 내용
                    style: TextStyle(
                        color: Color.fromARGB(255, 126, 113, 159), // 버튼 텍스트 색상
                        decoration: TextDecoration.underline),
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
                          print(
                              '${filteredBooks[index]["title"]} 카드가 클릭되었습니다.');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoredBookDetail(
                                title: filteredBooks[index]["title"]!,
                                image: filteredBooks[index]["image"]!,
                                author: filteredBooks[index]["author"]!,
                                description: filteredBooks[index]
                                    ["description"]!,
                                status: filteredBooks[index]["status"]!,
                                startDay: filteredBooks[index]["startDay"]!, // 임시 데이터 전송
                                endDay: filteredBooks[index]["endDay"]!,
                                publisher: filteredBooks[index]["publisher"]!,
                                publishYear: filteredBooks[index]["publishYear"]!,
                                publishMonth: filteredBooks[index]["publishMonth"]!,
                                totalPages: filteredBooks[index]["totalPages"]!,
                                readPages: filteredBooks[index]["readPages"]!,
                                collection: filteredBooks[index]["collection"],
                                review: filteredBooks[index]["review"],
                                bookReport: filteredBooks[index]["bookReport"],
                                rating: filteredBooks[index]["rating"],
                                isStored: filteredBooks[index]["isStored"],
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
          padding: const EdgeInsets.only(
              bottom: 16.0, right: 16.0, left: 16.0), // 외부 여백
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
                      mainAxisSize: MainAxisSize.min, // Column의 크기를 자식 요소에 맞춤
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // StoredBookDetail 페이지로 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoredBookDetail(
                                        title: filteredBooks[index]["title"]!,
                                        image: filteredBooks[index]["image"]!,
                                        author: filteredBooks[index]["author"]!,
                                        description: filteredBooks[index]["description"]!,
                                        status: filteredBooks[index]["status"]!,
                                        startDay: filteredBooks[index]["startDay"]!, // 임시 데이터 전송
                                        endDay: filteredBooks[index]["endDay"]!,
                                        publisher: filteredBooks[index]["publisher"]!,
                                        publishYear: filteredBooks[index]["publishYear"]!,
                                        publishMonth: filteredBooks[index]["publishMonth"]!,
                                        totalPages: filteredBooks[index]["totalPages"]!,
                                        readPages: filteredBooks[index]["readPages"]!,
                                        collection: filteredBooks[index]["collection"],
                                        review: filteredBooks[index]["review"],
                                        bookReport: filteredBooks[index]["bookReport"],
                                        rating: filteredBooks[index]["rating"],
                                        isStored: filteredBooks[index]["isStored"],
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
                                borderRadius: BorderRadius.circular(10), // 카드 둥근 모서리
                                child: Image.asset(
                                  filteredBooks[index]["image"]!,
                                  fit: BoxFit.cover, // 이미지를 카드에 꽉 차게
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        // 진행 바와 텍스트
                        SizedBox(
                          width: 110, // 진행 바의 너비
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10), // 둥근 끝을 위한 반경 설정
                            child: LinearProgressIndicator(
                              value: filteredBooks[index]["totalPages"] > 0
                                  ? (filteredBooks[index]["readPages"] / filteredBooks[index]["totalPages"]).clamp(0.0, 1.0) // 진행 상태 계산
                                  : 0.0, // 페이지가 0일 경우 0
                              backgroundColor: Colors.grey[200], // 배경색
                              valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 126, 113, 200)), // 진행 색상
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
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
                alignment: Alignment.topRight, // 오른쪽 상단에 버튼을 배치
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "편집", // 텍스트 버튼의 내용
                    style: TextStyle(
                        color: Color.fromARGB(255, 126, 113, 159), // 버튼 텍스트 색상
                        decoration: TextDecoration.underline),
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
                                startDay: filteredBooks[index]["startDay"]!, // 임시 데이터 전송
                                endDay: filteredBooks[index]["endDay"]!,
                                publisher: filteredBooks[index]["publisher"]!,
                                publishYear: filteredBooks[index]["publishYear"]!,
                                publishMonth: filteredBooks[index]["publishMonth"]!,
                                totalPages: filteredBooks[index]["totalPages"]!,
                                readPages: filteredBooks[index]["readPages"]!,
                                collection: filteredBooks[index]["collection"],
                                review: filteredBooks[index]["review"],
                                bookReport: filteredBooks[index]["bookReport"],
                                rating: filteredBooks[index]["rating"],
                                isStored: filteredBooks[index]["isStored"],
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
      case 3: // 컬렉션
        if (!_enterCollection) { // 컬렉션 리스트
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
                      // 다이얼로그 호출
                      showAddCollectionDialog(context, addCollection);
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
                            showAddCollectionDialog(context, addCollection);                        },
                          icon: Icon(
                            Icons.add, // '+' 아이콘
                            color: Color.fromARGB(255, 126, 113, 159),
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {  // 해당 컬렉션의 책 리스트
                  // 컬렉션 카드
                  return GestureDetector(
                    onTap: () {
                      // 현재 컬렉션 이름
                      String currentCollectionName = collections[index - 1];
                      print("${currentCollectionName} collection card clicked");
                      
                      setState(() {
                        _enterCollection = true;
                        _selectedCollection = currentCollectionName;
                      });
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
                              formatCollectionName(collections[index - 1]),
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
                                  _showEditCollectionDialog(context, index - 1);
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
        } 
        else {
          final filteredBooks = getFilteredCollectionBooks();
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0, right: 16.0, left: 16.0),
            child: Column(
              children: [
                // 드롭다운 버튼
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: Color.fromARGB(255, 223, 221, 227),
                        width: 1.5,
                      ),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedCollection,
                      isExpanded: true,
                      underline: SizedBox(),
                      icon: Icon(Icons.arrow_drop_down, color: Color.fromARGB(255, 126, 113, 159)),
                      dropdownColor: Colors.grey[200], // 드롭다운 배경색 설정 (여기서 색상을 설정)
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCollection = newValue!;
                          print('선택된 컬렉션: $_selectedCollection');
                        });
                      },
                      items: collections.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            color: Colors.grey[200], // 각 항목 배경 색상
                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                            child: Text(
                              value,
                              style: TextStyle(
                                color: Color.fromARGB(255, 126, 113, 159),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
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
                                  startDay: filteredBooks[index]["startDay"]!, // 임시 데이터 전송
                                  endDay: filteredBooks[index]["endDay"]!,
                                  publisher: filteredBooks[index]["publisher"]!,
                                  publishYear: filteredBooks[index]["publishYear"]!,
                                  publishMonth: filteredBooks[index]["publishMonth"]!,
                                  totalPages: filteredBooks[index]["totalPages"]!,
                                  readPages: filteredBooks[index]["readPages"]!,
                                  collection: filteredBooks[index]["collection"],
                                  review: filteredBooks[index]["review"],
                                  bookReport: filteredBooks[index]["bookReport"],
                                  rating: filteredBooks[index]["rating"],
                                  isStored: filteredBooks[index]["isStored"],
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
      }
      default:
        return Center(child: Text("전체 책들 목록"));
    }
  }
}
