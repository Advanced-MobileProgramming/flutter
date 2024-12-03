import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddBook extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> book;
  final String readingStatus;
  final int selectedTabIndex;
  final int? bookId;

  //const AddBook({required this.userId, required this.book});
  const AddBook(
      {Key? key,
      required this.userId,
      required this.book,
      required this.readingStatus,
      required this.selectedTabIndex,
      required this.bookId})
      : super(key: key);

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  // int _currentTabIndex = 0; // 세그먼트 바 초기값
  // DateTime? _startDate;
  // DateTime? _endDate;
  // List<Map<String, dynamic>> collection = [];
  // String _selectCollection = "선택 안 함";
  // bool _isExpanded = false; // 리스트가 펼쳐져 있는지 여부
  int _currentTabIndex = 0;
  DateTime? _startDate;
  DateTime? _endDate;
  List<Map<String, dynamic>> collection = [];
  String _selectCollection = "선택 안 함";
  bool _isExpanded = false;
  late String readingStatus;
  TextEditingController _pagesReadController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _pagesReadController.text = widget.book["current_page"] != null
        ? '${widget.book["current_page"]}' // 페이지 값이 있으면 해당 값으로 초기화
        : '0'; // 없으면 기본값 '0'

    readingStatus = widget.readingStatus; // 초기값 설정
    _currentTabIndex = widget.selectedTabIndex; // 초기값 설정
    fetchStartDate(); // start_date 데이터 로드
    fetchCollections();
  }

  // Firebase에서 데이터 가져오는 코드 예시
  Future<void> fetchStartDate() async {
    try {
      DatabaseReference bookcasesRef = FirebaseDatabase.instance
          .ref("bookcases/${widget.userId}/${widget.bookId}");
      DataSnapshot snapshot = await bookcasesRef.get();
      if (snapshot.exists) {
        final bookData = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          _startDate = DateTime.parse(
              bookData["start_date"]); // start_date를 DateTime으로 변환
        });
      }
    } catch (e) {
      print("start_date 가져오기 오류: $e");
    }
  }

  // Firebase에서 콜렉션 데이터 가져오기
  // Future<void> fetchCollections() async {
  //   final DatabaseReference collectionsRef =
  //       FirebaseDatabase.instance.ref("collections");

  //   try {
  //     final snapshot = await collectionsRef.child(widget.userId).get();
  //     if (snapshot.exists) {
  //       final data = Map<String, dynamic>.from(snapshot.value as Map);
  //       setState(() {
  //         collection = data.entries
  //             .map((entry) => Map<String, dynamic>.from(entry.value))
  //             .toList();
  //       });
  //       print("collection 개수:${collection.length}");
  //     }
  //   } catch (e) {
  //     throw ("Firebase 데이터 가져오기 오류: $e");
  //   }
  // }
  // Future<void> fetchCollections() async {
  //   final DatabaseReference collectionsRef = FirebaseDatabase.instance.ref("collections");

  //   try {
  //     final snapshot = await collectionsRef.child(widget.userId).get();
  //     if (snapshot.exists) {
  //       final data = Map<String, dynamic>.from(snapshot.value as Map);
  //       setState(() {
  //         collection = data.entries.map((entry) => Map<String, dynamic>.from(entry.value)).toList();
  //       });
  //     }
  //   } catch (e) {
  //     print("Firebase 데이터 가져오기 오류: $e");
  //   }
  // }
  // Firebase에서 컬렉션 데이터 가져오기
  Future<void> fetchCollections() async {
    DatabaseReference collectionsRef =
        FirebaseDatabase.instance.ref("collections/${widget.userId}");
    try {
      DataSnapshot snapshot = await collectionsRef.get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          collection = data.entries
              .map((entry) => {
                    "collection_id": entry.key,
                    "collection_name": entry.value["collection_name"]
                  })
              .toList();
        });
      }
    } catch (e) {
      print("Firebase 데이터 가져오기 오류: $e");
    }
  }

// 선택한 컬렉션 ID 저장 및 UI에 표시
// void selectCollection(String collectionName) {
//   setState(() {
//     _selectCollection = collectionName;
//   });
// }
  void selectCollection(String collectionName) async {
    setState(() {
      _selectCollection = collectionName; // UI 업데이트
    });

    // "선택 안 함"일 경우, 저장하지 않고 종료
    if (collectionName == "선택 안 함") {
      print("컬렉션 선택 안 함: 저장하지 않습니다.");
      return;
    }

    // Firebase 업데이트
    final DatabaseReference bookcasesRef = FirebaseDatabase.instance
        .ref("bookcases/${widget.userId}/${widget.book["id"]}");
    //FirebaseDatabase.instance.ref("bookcases/${widget.userId}/${widget.book["id"].toString()}"); // 변환 추가

//   try {
//     await bookcasesRef.update({
//       "collection_name": collectionName, // 선택된 컬렉션 이름 저장
//     });
//     print("컬렉션 ${collectionName}이 성공적으로 저장되었습니다.");
//   } catch (e) {
//     print("컬렉션 저장 오류: $e");
//   }
// }

    print("저장 경로: bookcases/${widget.userId}/${widget.book["id"].toString()}");
    print(
        "저장 데이터: collection_name = $collectionName, reading_status = $readingStatus");

    try {
      // 읽기 상태 가져오기
      String readingStatus = _currentTabIndex == 0
          ? "읽기 전"
          : (_currentTabIndex == 1 ? "읽는 중" : "완료");

      await bookcasesRef.update({
        "collection_name": collectionName, // 선택된 컬렉션 이름 저장
        "reading_status": readingStatus, // 현재 읽기 상태도 함께 저장
      });
      print("컬렉션 ${collectionName}이 성공적으로 저장되었습니다. 읽기 상태: $readingStatus");
    } catch (e) {
      print("컬렉션 저장 오류: $e");
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // 책장에 책 추가 함수
  // Future<void> addBookcase(
  //     {required String userId,
  //     required String readingStatus,
  //     required Map<String, dynamic> book,
  //     String? pagesRead}) async {
  //   final DatabaseReference bookcasesRef =
  //       FirebaseDatabase.instance.ref("bookcases");
  //       final DatabaseReference collectionsRef = FirebaseDatabase.instance.ref("collections");

  //     // 선택한 컬렉션 ID 찾기
  // String? selectedCollectionId;
  // if (_selectCollection != "선택 안 함") {
  //   selectedCollectionId = collection.firstWhere(
  //     (col) => col["collection_name"] == _selectCollection,
  //     orElse: () => {"collection_id": null},
  //   )["collection_id"];
  // }

  //   final bookcaseData = {
  //     "user_id": userId,
  //     "book_id": book["id"],
  //     "book_image": book["image_path"],
  //     "collection_name": _selectCollection,
  //     "collection_id": selectedCollectionId, // 컬렉션 ID 추가
  //     "reading_status": readingStatus,
  //     "pages_read": pagesRead ?? 0,
  //     "start_date": _startDate,
  //     "end_date": _endDate
  //   };

  //   //await bookcasesRef.child(userId).child(book["id"]).set(bookcaseData);
  //   await bookcasesRef
  //   .child(userId)
  //   .child(book["id"].toString()) // int -> String 변환
  //   .set(bookcaseData);

  //   // 선택된 컬렉션에 책 추가
  // if (selectedCollectionId != null) {
  //   await collectionsRef
  //       .child(userId)
  //       .child(selectedCollectionId)
  //       .child("books")
  //       .child(book["id"].toString())
  //       .set(book);
  // }

  // print("책이 성공적으로 저장되었습니다.");
  // }

  // Future<void> addBookToBookcase() async {
  //   DatabaseReference bookcasesRef = FirebaseDatabase.instance.ref("bookcases/${widget.userId}");
  //   String? selectedCollectionId = collection.firstWhere(
  //     (col) => col["collection_name"] == _selectCollection,
  //     orElse: () => {"collection_id": null}
  //   )["collection_id"];

  //   final bookcaseData = {
  //     "user_id": widget.userId,
  //     "book_id": widget.book["id"],
  //     "book_image": widget.book["image_path"],
  //     "reading_status": _currentTabIndex == 0 ? "읽기 전" : (_currentTabIndex == 1 ? "읽는 중" : "완료"),
  //     "start_date": _startDate?.toIso8601String(),
  //     "end_date": _endDate?.toIso8601String(),
  //     "pages_read": _pagesReadController.text,
  //     "collection_id": selectedCollectionId,
  //     "collection_name": _selectCollection
  //   };

  //   await bookcasesRef.child(widget.book["id"].toString()).set(bookcaseData);
  //   print("책이 성공적으로 저장되었습니다.");
  // }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime initialDate =
        isStartDate ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
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
  // Future<void> _selectDate(BuildContext context, bool isStartDate) async {
  //   DateTime initialDate =
  //       isStartDate ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now();
  //   DateTime? selectedDate = await showDatePicker(
  //     context: context,
  //     initialDate: initialDate,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );

  //   if (selectedDate != null) {
  //     setState(() {
  //       if (isStartDate) {
  //         _startDate = selectedDate;
  //       } else {
  //         _endDate = selectedDate;
  //       }
  //     });
  //   }
  // }

  // 선택된 탭에 해당하는 콘텐츠를 반환하는 메소드
  Widget _getTabContent(int index) {
    switch (index) {
      case 0: // 읽기 전
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // 배경색
                  borderRadius: BorderRadius.circular(10), // 둥근 모서리 설정
                ),
                child: ExpansionTile(
                  key: UniqueKey(),
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _isExpanded = expanded; // 펼침/접힘 상태 업데이트
                    });
                  },
                  initiallyExpanded: _isExpanded, // 초기 상태 설정
                  title: Text(
                    _selectCollection,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  backgroundColor: Colors.white,
                  collapsedBackgroundColor: Colors.white,
                  children: [
                    Container(
                      height: 170, // 최대 높이 설정
                      child: ListView.builder(
                        shrinkWrap: true, // ListView가 무한히 확장되지 않도록 설정
                        physics: BouncingScrollPhysics(),
                        itemCount: collection.length + 1, // 리스트 항목 수
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // "선택 안 함" 처리
                            return Column(
                              children: [
                                ListTile(
                                  title: Text('선택 안 함'),
                                  onTap: () async {
                                    print("선택 안 함을 클릭했습니다.");
                                    setState(() {
                                      _selectCollection = "선택 안 함";
                                      _isExpanded = false;
                                    });

                                    // Firebase에서 "선택 안 함"으로 업데이트
                                    final DatabaseReference bookcasesRef =
                                        FirebaseDatabase.instance.ref(
                                            "bookcases/${widget.userId}/${widget.book["id"]}");

                                    try {
                                      await bookcasesRef.update({
                                        "collection_name": "선택 안 함",
                                        "reading_status": "읽기 전", // 읽기 상태 업데이트
                                      });
                                      print("컬렉션 '선택 안 함'으로 성공적으로 업데이트되었습니다.");
                                    } catch (e) {
                                      print("컬렉션 업데이트 오류: $e");
                                    }
                                  },
                                ),
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                ),
                              ],
                            );
                          }

                          // 컬렉션 항목 처리
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                    '${collection[index - 1]["collection_name"]}'),
                                onTap: () async {
                                  print(
                                      "컬렉션 ${collection[index - 1]["collection_name"]}을 선택했습니다.");

                                  setState(() {
                                    _selectCollection = collection[index - 1]
                                        ["collection_name"];
                                    _isExpanded = false;
                                  });

                                  // 책을 선택한 컬렉션에 저장
                                  final selectedCollectionId =
                                      collection[index - 1]["collection_id"];

                                  final DatabaseReference bookcasesRef =
                                      FirebaseDatabase.instance.ref(
                                          "bookcases/${widget.userId}/${widget.book["id"]}");

                                  try {
                                    await bookcasesRef.update({
                                      "collection_name": collection[index - 1]
                                          ["collection_name"], // 선택된 컬렉션 이름 저장
                                      "reading_status": "읽기 전", // 읽기 상태도 함께 저장
                                    });
                                    print(
                                        "컬렉션 ${collection[index - 1]["collection_name"]}으로 성공적으로 업데이트되었습니다.");
                                  } catch (e) {
                                    print("컬렉션 저장 오류: $e");
                                  }
                                },
                              ),
                              if (index < collection.length)
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

      // case 0: // 읽기 전
      //   return Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: Column(
      //       children: [
      //         // ExpansionTile을 감싸는 Container에 borderRadius 설정
      //         Container(
      //           decoration: BoxDecoration(
      //             color: Colors.white, // 배경색
      //             borderRadius: BorderRadius.circular(10), // 둥근 모서리 설정
      //           ),
      //           child: ExpansionTile(
      //             key: UniqueKey(),
      //             onExpansionChanged: (expanded) {
      //               setState(() {
      //                 _isExpanded = expanded; // 펼침/접힘 상태 업데이트
      //               });
      //             },
      //             initiallyExpanded: _isExpanded, // 초기 상태 설정
      //             title: Text(
      //               _selectCollection,
      //               style:
      //                   TextStyle(fontSize: 16, color: Colors.black), // 텍스트 색상
      //             ),
      //             backgroundColor: Colors.white, // 열렸을 때 배경 색상
      //             collapsedBackgroundColor: Colors.white, // 닫혔을 때 배경 색상
      //             children: [
      //               // ListView를 Container로 감싸서 최대 높이 설정
      //               Container(
      //                 height: 170, // 최대 높이 설정
      //                 child: ListView.builder(
      //                   shrinkWrap: true, // ListView가 무한히 확장되지 않도록 설정
      //                   physics: BouncingScrollPhysics(), // 리스트만 스크롤되도록 설정
      //                   itemCount: collection.length + 1, // 리스트 항목 수
      //                   itemBuilder: (context, index) {
      //                     // "컬렉션 선택 안 함" 항목 처리
      //                     if (index == 0) {
      //                       return Column(
      //                         children: [
      //                           ListTile(
      //                             title: Text('선택 안 함'),
      //                             onTap: () {
      //                               print("선택 안 함을 클릭했습니다.");
      //                               setState(() {
      //                                 _selectCollection = "선택 안 함";
      //                                 _isExpanded = false;
      //                               });
      //                             },
      //                           ),
      //                           Divider(
      //                             height: 1, // 보더라인 위아래 간격 설정
      //                             thickness: 1, // 보더라인 두께 설정
      //                           ),
      //                         ],
      //                       );
      //                     }

      //                     // 컬렉션 항목 처리
      //                     return Column(
      //                       children: [
      //                         ListTile(
      //                           title: Text(
      //                               '${collection[index - 1]["collection_name"]}'),
      //                           onTap: () {
      //                             print(
      //                                 "컬렉션 ${collection[index - 1]["collection_name"]}을 클릭했습니다.");
      //                             setState(() {
      //                               _selectCollection = collection[index - 1]
      //                                   ["collection_name"];
      //                               _isExpanded = false;
      //                             });
      //                           },
      //                         ),
      //                         // 보더라인 추가 (마지막 항목 이후에는 보더라인 추가 안 함)
      //                         if (index < 4)
      //                           Divider(
      //                             height: 1, // 보더라인 위아래 간격 설정
      //                             thickness: 1, // 보더라인 두께 설정
      //                           ),
      //                       ],
      //                     );
      //                   },
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   );
      case 1: // 읽는 중
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 시작일
              Row(
                children: [
                  Text("시작일  ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 126, 113, 159))),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () =>
                        _selectDate(context, true), // 텍스트 클릭 시 날짜 선택 동작
                    child: Text(
                      _startDate != null
                          //? '${_startDate!.toLocal().toString().split(' ')[0]}'
                          ? '${formatDate(_startDate!)}' // formatDate를 사용하여 포맷된 날짜 출력
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
                  Text("독서량  ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 126, 113, 159))),
                  SizedBox(width: 16),
                  //               Container(
                  //                 width: 100, // 현재 페이지 입력 필드
                  //                 child: TextField(
                  //                   keyboardType: TextInputType.number,
                  //                   onChanged: (value) async {
                  // int newPage = int.tryParse(value) ?? 0;
                  Container(
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _pagesReadController,
                      onChanged: (value) async {
                        int newPage = int.tryParse(value) ?? 0;
                        //       controller: TextEditingController(
                        //                         text: '${widget.book["current_page"]}'),
                        //                     keyboardType: TextInputType.number,
                        //                     onChanged: (value) async {
                        //                       int newPage = int.tryParse(value) ?? 0;

                        // Firebase 업데이트 로직
                        final DatabaseReference bookcasesRef =
                            FirebaseDatabase.instance.ref(
                                "bookcases/${widget.userId}/${widget.book["id"]}");

                        try {
                          // 전체 페이지 수 가져오기
                          int totalPages = widget.book["page"] ?? 0;

                          // 읽기 상태 결정
                          String newStatus;
                          if (newPage == 0) {
                            newStatus = "읽기 전";
                          } else if (newPage > 0 && newPage < totalPages) {
                            newStatus = "읽는 중";
                          } else if (newPage >= totalPages) {
                            newStatus = "완료";
                          } else {
                            newStatus = "읽기 전";
                          }

                          // Firebase 업데이트
                          await bookcasesRef.update({
                            "current_page": newPage, // 새로운 페이지 값
                            "reading_status": newStatus, // 새로운 읽기 상태
                          });

                          // 로컬 상태 업데이트
                          setState(() {
                            widget.book["current_page"] = newPage;
                            widget.book["reading_status"] = newStatus;
                          });

                          print("페이지와 읽기 상태가 업데이트되었습니다.");
                        } catch (e) {
                          print("페이지 업데이트 오류: $e");
                        }
                      },

//   controller: TextEditingController(
//   text: widget.book["current_page"] != null ? '${widget.book["current_page"]}' : '0',
// ),
// keyboardType: TextInputType.number,
// onChanged: (value) async {
//   int newPage = int.tryParse(value) ?? 0;

//   // 수정된 값 로그 출력
//   print("현재 페이지 값: ${widget.book["current_page"]}");
//   print("변경된 페이지: $newPage");  // 새 페이지가 제대로 반영되는지 확인

//   final DatabaseReference bookcasesRef =
//       FirebaseDatabase.instance.ref("bookcases/${widget.userId}/${widget.bookId}");

//   try {
//     await bookcasesRef.update({
//       "current_page": newPage,  // 새로운 페이지 값 업데이트
//     });
//     print("페이지 값이 Firebase에 업데이트되었습니다.");

//     setState(() {
//       widget.book["current_page"] = newPage; // widget의 book 정보에 반영
//     });
//   } catch (e) {
//     print("페이지 업데이트 오류: $e");
//   }
// },
                      decoration: InputDecoration(
                        //hintText: '현재 페이지',
                        hintText: widget.book["current_page"] != null &&
                                widget.book["current_page"]
                                    .toString()
                                    .isNotEmpty
                            ? '${widget.book["current_page"]}'
                            : '0', // 페이지가 없으면 '0' 기본값
                        filled: true, // 배경색 활성화
                        fillColor: Color.fromARGB(255, 250, 248, 240), // 배경색 설정
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12), // 둥근 테두리 설정
                          borderSide: BorderSide(
                            color:
                                Color.fromARGB(255, 126, 113, 159), // 테두리 색 설정
                            width: 1.5, // 테두리 두께
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12), // 비활성 상태 둥근 테두리
                          borderSide: BorderSide(
                            color:
                                Color.fromARGB(255, 180, 167, 200), // 테두리 색 설정
                            width: 1.5, // 테두리 두께
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12), // 포커스 상태 둥근 테두리
                          borderSide: BorderSide(
                            color:
                                Color.fromARGB(255, 126, 113, 159), // 포커스 테두리 색
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
                  // Text(
                  //   widget.book["page"] != null ? 'widget.book["page"]' : '0',
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //     color: Color.fromARGB(255, 126, 113, 159),
                  //   ),
                  // ),
                  Text(
                    widget.book["page"] != null
                        ? '${widget.book["page"]}'
                        : '0',
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
                  key: UniqueKey(),
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _isExpanded = expanded; // 펼침/접힘 상태 업데이트
                    });
                  },
                  initiallyExpanded: _isExpanded, // 초기 상태 설정
                  title: Text(
                    _selectCollection,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  backgroundColor: Colors.white,
                  collapsedBackgroundColor: Colors.white,
                  children: [
                    Container(
                      height: 170, // 최대 높이 설정
                      child: ListView.builder(
                        shrinkWrap: true, // ListView가 무한히 확장되지 않도록 설정
                        physics: BouncingScrollPhysics(),
                        itemCount: collection.length + 1, // 리스트 항목 수
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // "선택 안 함" 처리
                            return Column(
                              children: [
                                ListTile(
                                  title: Text('선택 안 함'),
                                  onTap: () async {
                                    print("선택 안 함을 클릭했습니다.");
                                    setState(() {
                                      _selectCollection = "선택 안 함";
                                      _isExpanded = false;
                                    });

                                    // Firebase에서 "선택 안 함"으로 업데이트
                                    final DatabaseReference bookcasesRef =
                                        FirebaseDatabase.instance.ref(
                                            "bookcases/${widget.userId}/${widget.book["id"]}");

                                    try {
                                      await bookcasesRef.update({
                                        "collection_name": "선택 안 함",
                                        "reading_status": "읽는 중", // 읽기 상태 업데이트
                                      });
                                      print("컬렉션 '선택 안 함'으로 성공적으로 업데이트되었습니다.");
                                    } catch (e) {
                                      print("컬렉션 업데이트 오류: $e");
                                    }
                                  },
                                ),
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                ),
                              ],
                            );
                          }

                          // 컬렉션 항목 처리
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                    '${collection[index - 1]["collection_name"]}'),
                                onTap: () async {
                                  print(
                                      "컬렉션 ${collection[index - 1]["collection_name"]}을 선택했습니다.");

                                  setState(() {
                                    _selectCollection = collection[index - 1]
                                        ["collection_name"];
                                    _isExpanded = false;
                                  });

                                  // 책을 선택한 컬렉션에 저장
                                  final selectedCollectionId =
                                      collection[index - 1]["collection_id"];

                                  final DatabaseReference bookcasesRef =
                                      FirebaseDatabase.instance.ref(
                                          "bookcases/${widget.userId}/${widget.book["id"]}");

                                  try {
                                    await bookcasesRef.update({
                                      "collection_name": collection[index - 1]
                                          ["collection_name"], // 선택된 컬렉션 이름 저장
                                      "reading_status": "읽는 중", // 읽기 상태도 함께 저장
                                    });
                                    print(
                                        "컬렉션 ${collection[index - 1]["collection_name"]}으로 성공적으로 업데이트되었습니다.");
                                  } catch (e) {
                                    print("컬렉션 저장 오류: $e");
                                  }
                                },
                              ),
                              if (index < collection.length)
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
                  Text("시작일  ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 126, 113, 159))),
                  SizedBox(width: 16), // 간격 추가
                  GestureDetector(
                    onTap: () =>
                        _selectDate(context, true), // 텍스트 클릭 시 날짜 선택 동작
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
                  Text("종료일  ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 126, 113, 159))),
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
                  key: UniqueKey(),
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _isExpanded = expanded; // 펼침/접힘 상태 업데이트
                    });
                  },
                  initiallyExpanded: _isExpanded, // 초기 상태 설정
                  title: Text(
                    _selectCollection,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  backgroundColor: Colors.white,
                  collapsedBackgroundColor: Colors.white,
                  children: [
                    Container(
                      height: 170, // 최대 높이 설정
                      child: ListView.builder(
                        shrinkWrap: true, // ListView가 무한히 확장되지 않도록 설정
                        physics: BouncingScrollPhysics(),
                        itemCount: collection.length + 1, // 리스트 항목 수
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // "선택 안 함" 처리
                            return Column(
                              children: [
                                ListTile(
                                  title: Text('선택 안 함'),
                                  onTap: () async {
                                    print("선택 안 함을 클릭했습니다.");
                                    setState(() {
                                      _selectCollection = "선택 안 함";
                                      _isExpanded = false;
                                    });

                                    // Firebase에서 "선택 안 함"으로 업데이트
                                    final DatabaseReference bookcasesRef =
                                        FirebaseDatabase.instance.ref(
                                            "bookcases/${widget.userId}/${widget.book["id"]}");

                                    try {
                                      await bookcasesRef.update({
                                        "collection_name": "선택 안 함",
                                        "reading_status": "완료", // 읽기 상태 업데이트
                                      });
                                      print("컬렉션 '선택 안 함'으로 성공적으로 업데이트되었습니다.");
                                    } catch (e) {
                                      print("컬렉션 업데이트 오류: $e");
                                    }
                                  },
                                ),
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                ),
                              ],
                            );
                          }

                          // 컬렉션 항목 처리
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                    '${collection[index - 1]["collection_name"]}'),
                                onTap: () async {
                                  print(
                                      "컬렉션 ${collection[index - 1]["collection_name"]}을 선택했습니다.");

                                  setState(() {
                                    _selectCollection = collection[index - 1]
                                        ["collection_name"];
                                    _isExpanded = false;
                                  });

                                  // 책을 선택한 컬렉션에 저장
                                  final selectedCollectionId =
                                      collection[index - 1]["collection_id"];

                                  final DatabaseReference bookcasesRef =
                                      FirebaseDatabase.instance.ref(
                                          "bookcases/${widget.userId}/${widget.book["id"]}");

                                  try {
                                    await bookcasesRef.update({
                                      "collection_name": collection[index - 1]
                                          ["collection_name"], // 선택된 컬렉션 이름 저장
                                      "reading_status": "완료", // 읽기 상태도 함께 저장
                                    });
                                    print(
                                        "컬렉션 ${collection[index - 1]["collection_name"]}으로 성공적으로 업데이트되었습니다.");
                                  } catch (e) {
                                    print("컬렉션 저장 오류: $e");
                                  }
                                },
                              ),
                              if (index < collection.length)
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
