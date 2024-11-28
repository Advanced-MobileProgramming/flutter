import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddBook extends StatefulWidget {
  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  int _currentTabIndex = 0; // 세그먼트 바 초기값
  DateTime? _startDate;
  DateTime? _endDate;
  int? _totalPages; // 전체 페이지 수

  @override
  void initState() {
    super.initState();
    // Firebase에서 책 정보 불러오기
    _loadBookData();
  }

  // Firebase에서 책 정보를 불러오는 함수
  Future<void> _loadBookData() async {
    try {
      // Realtime Database에서 데이터를 가져옵니다.
      DatabaseReference bookRef = FirebaseDatabase.instance
          .ref()
          .child('books') // 'books' 노드를 참조
          .child('your_book_id'); // 책의 ID에 맞는 경로를 지정

      DataSnapshot snapshot = await bookRef.get();

      if (snapshot.exists) {
        var bookData = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _totalPages =
              bookData['totalPages']; // Firebase 데이터에서 totalPages 값 가져오기
        });
      } else {
        print('책 정보를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('데이터를 불러오는 중 오류 발생: $e');
    }
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
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
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
            fontSize: 15, // 폰트 크기 설정
            color: _currentTabIndex == index
                ? Color.fromARGB(255, 70, 12, 230) // 선택된 탭은 색 변경
                : Colors.black,
          ),
          textAlign: TextAlign.center, // 텍스트가 중앙에 위치하도록 설정
        ),
      ),
    );
  }

  // 날짜 선택 함수
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initialDate =
        isStartDate ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = selectedDate;
        } else {
          _endDate = selectedDate;
        }
      });
    }
  }

  // 선택된 탭에 해당하는 콘텐츠를 반환하는 메소드
  Widget _getTabContent(int index) {
    switch (index) {
      case 0: // 읽기 전
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // ExpansionTile을 감싸는 Container에 borderRadius 설정
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // 배경색
                  borderRadius: BorderRadius.circular(10), // 둥근 모서리 설정
                ),
                child: ExpansionTile(
                  title: Text(
                    "컬렉션 선택",
                    style:
                        TextStyle(fontSize: 16, color: Colors.black), // 텍스트 색상
                  ),
                  backgroundColor: Colors.white, // 열렸을 때 배경 색상
                  collapsedBackgroundColor: Colors.white, // 닫혔을 때 배경 색상
                  children: [
                    // ListView를 Container로 감싸서 최대 높이 설정
                    Container(
                      height: 170, // 최대 높이 설정
                      child: ListView.builder(
                        shrinkWrap: true, // ListView가 무한히 확장되지 않도록 설정
                        physics: BouncingScrollPhysics(), // 리스트만 스크롤되도록 설정
                        itemCount: 5, // 리스트 항목 수
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text('컬렉션 ${index + 1}'),
                                onTap: () {
                                  // 클릭 시 동작 추가 가능
                                  print("컬렉션 ${index + 1}을 클릭했습니다.");
                                },
                              ),
                              // 보더라인 추가
                              if (index < 4)
                                Divider(
                                  height: 1, // 보더라인 위아래 간격 설정
                                  thickness: 1, // 보더라인 두께 설정
                                ), // 마지막 항목 이후에는 보더라인을 추가하지 않음
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case 1: // 읽는 중
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 시작일
              Row(
                children: [
                  Text(
                    "시작일  ",
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 126, 113, 159)
                    )
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context, true), // 텍스트 클릭 시 날짜 선택 동작
                    child: Text(
                      _startDate != null
                          ? '${_startDate!.toLocal().toString().split(' ')[0]}'
                          : '날짜 선택',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 126, 113, 159),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
              SizedBox(height: 16),
              // 독서량: 현재 페이지 / 총 페이지
              Row(
                children: [
                  Text(
                    "독서량  ",
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 126, 113, 159)
                    )
                  ),
                  SizedBox(width: 16),
Container(
  width: 100, // 현재 페이지 입력 필드
  child: TextField(
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      hintText: '현재 페이지',
      filled: true, // 배경색 활성화
      fillColor: Color.fromARGB(255, 250, 248, 240), // 배경색 설정
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // 둥근 테두리 설정
        borderSide: BorderSide(
          color: Color.fromARGB(255, 126, 113, 159), // 테두리 색 설정
          width: 1.5, // 테두리 두께
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // 비활성 상태 둥근 테두리
        borderSide: BorderSide(
          color: Color.fromARGB(255, 180, 167, 200), // 테두리 색 설정
          width: 1.5, // 테두리 두께
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // 포커스 상태 둥근 테두리
        borderSide: BorderSide(
          color: Color.fromARGB(255, 126, 113, 159), // 포커스 테두리 색
          width: 2.0, // 테두리 두께
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 10,
      ), // 내용 여백 설정
    ),
  ),
),

                  SizedBox(width: 16),
                  Text(
                    "/",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 126, 113, 159),
                    ),
                  ), // 구분자
                  SizedBox(width: 16),
                  Text(
                    _totalPages != null ? '$_totalPages' : '0',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 126, 113, 159),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    "p",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 126, 113, 159),
                    ),
                  ), // "p" 표시
                ],
              ),
              SizedBox(height: 16),
              // 컬렉션 선택
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpansionTile(
                  title: Text("컬렉션 선택",
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                  backgroundColor: Colors.white,
                  collapsedBackgroundColor: Colors.white,
                  children: [
                    Container(
                      height: 90,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text('컬렉션 ${index + 1}'),
                                onTap: () {
                                  print("컬렉션 ${index + 1}을 클릭했습니다.");
                                },
                              ),
                              if (index < 4)
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case 2: // 완료
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 시작일
              Row(
                children: [
                  Text(
                    "시작일  ",
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 126, 113, 159)
                    )
                  ),
                  SizedBox(width: 16), // 간격 추가
                  GestureDetector(
                    onTap: () => _selectDate(context, true), // 텍스트 클릭 시 날짜 선택 동작
                    child: Text(
                      _startDate != null
                          ? '${_startDate!.toLocal().toString().split(' ')[0]}'
                          : '날짜 선택',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 126, 113, 159),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
              SizedBox(height: 16),
              // 종료일
              Row(
                children: [
                  Text(
                    "종료일  ",
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 126, 113, 159)
                    )
                  ),
                  SizedBox(width: 16), // 간격 추가
                  GestureDetector(
                    onTap: () => _selectDate(context, false), // 텍스트 클릭 시 동작
                    child: Text(
                      _endDate != null
                          ? '${_endDate!.toLocal().toString().split(' ')[0]}'
                          : '날짜 선택',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 126, 113, 159),
                      ),
                    ),
                  ),
                  SizedBox(width: 16), // 간격 유지
                ],
              ),
              SizedBox(height: 16),
              // 컬렉션 선택
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // 배경색
                  borderRadius: BorderRadius.circular(10), // 둥근 모서리 설정
                ),
                child: ExpansionTile(
                  title: Text(
                    "컬렉션 선택",
                    style:
                        TextStyle(fontSize: 16, color: Colors.black), // 텍스트 색상
                  ),
                  backgroundColor: Colors.white, // 열렸을 때 배경 색상
                  collapsedBackgroundColor: Colors.white, // 닫혔을 때 배경 색상
                  children: [
                    // ListView를 Container로 감싸서 최대 높이 설정
                    Container(
                      height: 100, // 최대 높이 설정
                      child: ListView.builder(
                        shrinkWrap: true, // ListView가 무한히 확장되지 않도록 설정
                        physics: BouncingScrollPhysics(), // 리스트만 스크롤되도록 설정
                        itemCount: 5, // 리스트 항목 수
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text('컬렉션 ${index + 1}'),
                                onTap: () {
                                  // 클릭 시 동작 추가 가능
                                  print("컬렉션 ${index + 1}을 클릭했습니다.");
                                },
                              ),
                              // 보더라인 추가
                              if (index < 4)
                                Divider(
                                  height: 1, // 보더라인 위아래 간격 설정
                                  thickness: 1, // 보더라인 두께 설정
                                ), // 마지막 항목 이후에는 보더라인을 추가하지 않음
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      default:
        return Center(child: Text("잘못된 탭입니다."));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      height: 450, // 모달 높이 설정
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 세그먼트 바 추가
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: _buildSegment('읽기 전', 0)),
                Expanded(child: _buildSegment('읽는 중', 1)),
                Expanded(child: _buildSegment('완료', 2)),
              ],
            ),
          ),
          // 탭에 해당하는 내용
          _getTabContent(_currentTabIndex),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
