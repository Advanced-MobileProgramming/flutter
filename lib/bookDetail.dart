import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // 사용 안할 시 삭제
import 'package:soobook/bookReportDetail.dart';
import 'package:soobook/reviewList.dart';
import 'package:soobook/addBook.dart';

class BookDetail extends StatefulWidget {
  final String userId;
  final int bookId;

  BookDetail({required this.userId, required this.bookId});

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  Map<String, dynamic> book = {};
  bool _isLoading = true; // 로딩 상태를 관리하는 변수 추가

  @override
  void initState() {
    super.initState();
    _checkBookState(); // 비동기 작업 시작
    fetchBook();
  }

  // Firebase에서 책 데이터 가져오기
  Future<void> fetchBook() async {
    final adjustedBookId = (widget.bookId - 1).toString(); // ID 변환
    final DatabaseReference booksRef =
        FirebaseDatabase.instance.ref("books").child(adjustedBookId);

  //       setState(() {
  //   _isLoading = true; // 로딩 시작
  //   book = {}; // book 초기화 (비어 있는 상태로 설정)
  // });

  //   try {
  //     final snapshot = await booksRef.get();

  //     if (snapshot.exists) {
  //       final bookData = Map<String, dynamic>.from(snapshot.value as Map);

  //       print("Fetched Data for Book ID: $adjustedBookId"); // 변환된 ID 로그
  //       print("Full Data: $bookData"); // 전체 데이터 로그
  //       print("Title: ${bookData['title'] ?? 'Not Found'}");
  //       print("Author: ${bookData['author'] ?? 'Not Found'}");
  //       print("Image Path: ${bookData['image_path'] ?? 'Not Found'}");
  //       print("Publisher: ${bookData['publisher'] ?? 'Not Found'}");
  //       print(
  //           "Publication Date: ${bookData['publication_date'] ?? 'Not Found'}");

  //       setState(() {
  //         book = bookData;

  //         if (book.containsKey("publication_date")) {
  //           final int timestamp = book["publication_date"];
  //           final publicationDate =
  //               DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  //           book["publication_year"] = publicationDate.year;
  //           book["publication_month"] = publicationDate.month;
  //         }
  //         _isLoading = false; // 로딩 상태 해제
  //       });
  //     } else {
  //       print("No data found for Book ID: $adjustedBookId");
  //       setState(() {
  //         _isLoading = false; // 로딩 상태 해제
  //       });
  //     }
  //   } catch (e) {
  //     print("Error fetching book data: $e");
  //     setState(() {
  //       _isLoading = false; // 로딩 상태 해제
  //     });
  //   }
//   setState(() {
//   _isLoading = true; // 로딩 시작
//   book = {}; // book 초기화 (비어 있는 상태로 설정)
// });


// try {
//   final snapshot = await booksRef.get();

//   if (snapshot.exists) {
//     final bookData = Map<String, dynamic>.from(snapshot.value as Map);

//     setState(() {
//       book = bookData;

//       // publication_date 변환 로직 추가
//       if (book.containsKey("publication_date")) {
//         final int timestamp = book["publication_date"];
//         final publicationDate =
//             DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

//         book["publication_year"] = publicationDate.year;
//         book["publication_month"] = publicationDate.month;
//       }
//       _isLoading = false; // 로딩 상태 해제
//     });
//   } else {
//     setState(() {
//       _isLoading = false; // 로딩 상태 해제
//     });
//   }
// } catch (e) {
//   print("Error fetching book data: $e");
//   setState(() {
//     _isLoading = false; // 로딩 상태 해제
//   });
// }

//   }
try {
    final snapshot = await booksRef.get();

    if (snapshot.exists) {
      final bookData = Map<String, dynamic>.from(snapshot.value as Map);

      setState(() {
        book = bookData;

        // start_date와 end_date 로그 찍기
        print("start_date: ${book['start_date']}");
        print("end_date: ${book['end_date']}");

        // publication_date 변환 로직
        if (book.containsKey("publication_date")) {
          final int timestamp = book["publication_date"];
          final publicationDate =
              DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

          book["publication_year"] = publicationDate.year;
          book["publication_month"] = publicationDate.month;
        }
        _isLoading = false; // 로딩 상태 해제
      });
    } else {
      setState(() {
        _isLoading = false; // 로딩 상태 해제
      });
    }
  } catch (e) {
    print("Error fetching book data: $e");
    setState(() {
      _isLoading = false; // 로딩 상태 해제
    });
  }
}

  // void addToBookcases() async {
  //   final DatabaseReference bookcasesRef =
  //       FirebaseDatabase.instance.ref("bookcases");

  //   try {
  //     await bookcasesRef
  //         .child(widget.userId)
  //         .child(widget.bookId.toString())
  //         .set(book);
  //     print("책을 책장에 추가했습니다.");
  //   } catch (e) {
  //     print("책 추가 오류: $e");
  //   }
  // }

  void addToBookcases({
  required String userId,
  required int bookId,
  required Map<String, dynamic> bookInfo,
  required DateTime? startDate,
  required DateTime? endDate,
  required int currentPage,
  required String readingStatus,
  required String collectionName,
}) async {
  final DatabaseReference bookcasesRef = FirebaseDatabase.instance.ref("bookcases");

  try {
    Map<String, dynamic> bookcaseData = {
      "user_id": userId,
      "book_id": bookId.toString(),
      "book_info": bookInfo, // 책 정보 전체 저장
      "start_date": startDate?.toIso8601String() ?? "", // null인 경우 빈 문자열 처리
      "end_date": endDate?.toIso8601String() ?? "",   // null인 경우 빈 문자열 처리
      "current_page": currentPage, // 현재 페이지 저장
      "reading_status": readingStatus, // 읽기 상태 저장
      "collection_name": collectionName, // 선택한 컬렉션 이름 저장
    };

    await bookcasesRef.child(userId).child(bookId.toString()).set(bookcaseData);
    print("책 정보가 성공적으로 저장되었습니다.");
  } catch (e) {
    print("책 정보 저장 오류: $e");
  }
}



//   Future<void> _checkBookState() async {
//   try {
//     final isStored = await isItStored(widget.userId, widget.bookId);

//     if (isStored) {
//       // 저장된 책의 상세 화면으로 이동
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => StoredBookDetail(userId: widget.userId, book: book),
//         ),
//       );
//     } else {
//       // 저장되지 않은 책의 상세 화면으로 이동
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => UnstoredBookDetail(
//             userId: widget.userId,
//             book: book,
//             bookId: widget.bookId,
//           ),
//         ),
//       );
//     }
//   } catch (e) {
//     print("Error checking book state: $e");
//     // 오류 처리
//   }
// }

Future<void> _checkBookState() async {
  try {
    final isStored = await isItStored(widget.userId, widget.bookId);

    if (isStored) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StoredBookDetail(userId: widget.userId, book: book),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UnstoredBookDetail(
            userId: widget.userId,
            book: book,
            bookId: widget.bookId,
          ),
        ),
      );
    }
  } catch (e) {
    print("Error checking book state: $e");
  }
}


  Future<bool> isItStored(String userId, int bookId) async {
    final adjustedBookId = (bookId).toString(); // ID 변환
    final DatabaseReference bookRef =
        FirebaseDatabase.instance.ref("bookcases/$userId/$adjustedBookId");

    print(
        "Checking if Book ID $adjustedBookId is stored in bookcases."); // 로그 추가

    try {
      final snapshot = await bookRef.get();
      if (snapshot.exists) {
        print("Book ID $adjustedBookId is stored in bookcases."); // 저장된 경우 로그
        return true;
      } else {
        print(
            "Book ID $adjustedBookId is not stored in bookcases."); // 저장되지 않은 경우 로그
        return false;
      }
    } catch (e) {
      print("Error checking book storage for Book ID $adjustedBookId: $e");
      return false;
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("책 상세 정보")),
    body: _isLoading
        ? Center(
            child: CircularProgressIndicator(), // 로딩 중 표시
          )
        : (book.isNotEmpty
            ? Center(
                child: Text(
                  "책 데이터가 로드되었습니다.", // 실제 UI로 대체하세요.
                  style: TextStyle(fontSize: 16),
                ),
              )
            : Center(
                child: Text(
                  "책 데이터를 불러올 수 없습니다.", // 데이터가 없는 경우 처리
                  style: TextStyle(fontSize: 16),
                ),
              )),
  );
}

}

// 저장되지 않은 책 상태
class UnstoredBookDetail extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> book;
  final int bookId; // bookId를 추가합니다.

  UnstoredBookDetail(
      {required this.userId, required this.book, required this.bookId});

  @override
  _UnstoredBookDetailState createState() => _UnstoredBookDetailState();
}

class _UnstoredBookDetailState extends State<UnstoredBookDetail> {
  int _currentTabIndex = 0; // 세그먼트 바 초기값

  // 리뷰 데이터
  final List<Map<String, dynamic>> reviews = [];

  // 새로운 리뷰를 위한 상태 변수
  final TextEditingController _reviewController = TextEditingController();
  double _currentRating = 0.0;

  // void addToBookcases({required String userId, required int bookId, required Map<String, dynamic> bookInfo, required DateTime startDate, required DateTime endDate, required int currentPage, required String readingStatus, required String collectionName}) async {
  //   final DatabaseReference bookcasesRef =
  //       FirebaseDatabase.instance.ref("bookcases");

  //   try {
  //     await bookcasesRef
  //         .child(widget.userId)
  //         .child(widget.bookId.toString())
  //         .set(widget.book);
  //     print("책을 책장에 추가했습니다.");
  //   } catch (e) {
  //     print("책 추가 오류: $e");
  //   }
  // }

  void addToBookcases({
  required String userId,
  required int bookId,
  required Map<String, dynamic> bookInfo,
  required DateTime? startDate,
  required DateTime? endDate,
  required int currentPage,
  required String readingStatus,
  required String collectionName,
}) async {
  final DatabaseReference bookcasesRef = FirebaseDatabase.instance.ref("bookcases");

  try {
    Map<String, dynamic> bookcaseData = {
      "user_id": userId,
      "book_id": bookId.toString(),
      "book_info": bookInfo, // 책 정보 전체 저장
      "start_date": startDate?.toIso8601String() ?? "", // null인 경우 빈 문자열 처리
      "end_date": endDate?.toIso8601String() ?? "",   // null인 경우 빈 문자열 처리
      "current_page": currentPage, // 현재 페이지 저장
      "reading_status": readingStatus, // 읽기 상태 저장
      "collection_name": collectionName, // 선택한 컬렉션 이름 저장
    };

    await bookcasesRef.child(userId).child(bookId.toString()).set(bookcaseData);
    print("책 정보가 성공적으로 저장되었습니다.");
  } catch (e) {
    print("책 정보 저장 오류: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '책 상세정보',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 126, 113, 159),
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // 뒤로 가기 버튼 비활성화
        toolbarHeight: 120.0,
        titleSpacing: 20.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 126, 113, 159),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 20.0, right: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar 밑줄
              Divider(
                  color: Color.fromARGB(255, 126, 113, 159), thickness: 0.5),
              SizedBox(height: 15),

              // 상단 섹션 (이미지, 제목, 저자, 출판연도)
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 책 이미지
                    Container(
                      width: 120,
                      height: 180,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // 그림자 색상
                            spreadRadius: 1, // 그림자 확산 범위
                            blurRadius: 5, // 그림자 흐림 정도
                            offset: Offset(0, 4), // 그림자의 위치 (x, y)
                          ),
                        ],
                      ),
                      child: Image.asset(
                        widget.book["image_path"] ??
                            'assets/images/books/3부작.jpg', // 하도 image_path에서 오류나길래 추가함
                        width: 120,
                        height: 160,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print("Error loading image: $error"); // 에러 로그
                          return Icon(Icons.image,
                              size: 100, color: Colors.grey);
                        },
                      ),
                    ),
                    SizedBox(width: 30),
                    // 제목, 저자, 출판연도 + 버튼
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            //widget.book["title"],
                            widget.book["title"] ?? 'No Title',
                            style: TextStyle(
                              color: Color.fromARGB(255, 126, 113, 159),
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "저자 | ${widget.book["author"]}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 126, 113, 159),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 45),
                          Row(
                            children: [
                              Text(
                                 "${widget.book["publisher"]} | ${widget.book["publication_year"]}년 ${widget.book["publication_month"]}월",
                                //"${widget.book["publisher"]} | ${widget.book["book_info"]?["publication_year"] ?? '출판연도 없음'}년 ${widget.book["book_info"]?["publication_month"] ?? '출판월 없음'}월",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB9AFD4),
                                  fontSize: 14,
                                ),
                              ),
                              Spacer(),
                              // IconButton(
                              //   icon: Icon(Icons.add_circle,
                              //       color: Color.fromARGB(255, 126, 113, 159),
                              //       size: 45),
                              //   onPressed: () {
                              //     addToBookcases(); // 책을 bookcases에 추가하는 함수 호출
                              //     // AddBook 모달 띄우기
                              //     showModalBottomSheet(
                              //       context: context,
                              //       builder: (BuildContext context) {
                              //         return AddBook(
                              //             userId: widget.userId,
                              //             book: widget
                              //                 .book); // AddBook 위젯을 호출하여 모달에 띄움
                              //       },
                              //     );
                              //   },
                              // )
                              IconButton(
  icon: Icon(Icons.add_circle, color: Color.fromARGB(255, 126, 113, 159), size: 45),
  onPressed: () {
    // 기본값 설정
    DateTime? startDate = null;
    DateTime? endDate = null;
    int currentPage = 0;
    String readingStatus = "읽기 전";
    String collectionName = "선택 안 함";

    // `addToBookcases` 호출
    addToBookcases(
      userId: widget.userId,
      bookId: widget.bookId,
      bookInfo: widget.book,
      startDate: startDate ?? DateTime.now(), // null이면 현재 시간 사용
      endDate: endDate ?? DateTime.now().add(Duration(days: 7)), // null이면 7일 후로 설정
      currentPage: currentPage,
      readingStatus: readingStatus,
      collectionName: collectionName,
    );

    // 저장 완료 메시지
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("책이 책장에 기본값으로 추가되었습니다.")),
    );

    // 모달 열기
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AddBook(userId: widget.userId, book: widget.book);
      },
    );
  },
)



                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),

              // 상단 섹션 밑줄
              Divider(
                  color: Color.fromARGB(255, 126, 113, 159), thickness: 0.5),
              SizedBox(height: 16),

              // 시작일과 종료일
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "시작일                         -",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 126, 113, 159),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "종료일                         -",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 126, 113, 159),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // 세그먼트 바
              Container(
                margin:
                    EdgeInsets.symmetric(vertical: 16), // 세그먼트 바와 콘텐츠 사이 여백 추가
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
                      child: _buildSegment('상세정보', 0),
                    ),
                    Expanded(
                      child: _buildSegment('리뷰', 1),
                    ),
                  ],
                ),
              ),
              // 탭에 해당하는 내용
              _getTabContent(_currentTabIndex),
            ],
          ),
        ),
      ),
    );
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

  // 선택된 탭에 해당하는 콘텐츠를 반환하는 메소드
  Widget _getTabContent(int index) {
    switch (index) {
      case 0: // 상세정보 탭
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "${widget.book["description"]}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color.fromARGB(255, 126, 113, 159),
            ),
          ),
        );
      case 1: // 리뷰 탭
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildReviewList(),
        );
      default:
        return Center(child: Text("잘못된 탭입니다."));
    }
  }

  // 리뷰 목록을 보여주는 메소드

  Widget _buildReviewList() {
    return ReviewList(reviews: reviews); // ReviewList 위젯 호출
  }
}

// 저장된 책 상태
class StoredBookDetail extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> book;

  StoredBookDetail({required this.userId, required this.book});

  @override
  _StoredBookDetailState createState() => _StoredBookDetailState();
}

class _StoredBookDetailState extends State<StoredBookDetail> {
  int _currentTabIndex = 0; // 세그먼트 바 초기값

  // book 객체에서 startDay와 endDay 가져오기
  //String get startDay => widget.book["start_day"] ?? ''; // start_day가 없으면 빈 문자열 반환
  //String get endDay => widget.book["end_day"] ?? ''; // end_day가 없으면 빈 문자열 반환

  // readPages가 book 객체에 포함되어 있다고 가정
  int get readPages => widget.book.containsKey("readPages")
      ? widget.book["readPages"]
      : 0; // readPages가 없으면 0으로 처리
  int get totalPages =>
      widget.book.containsKey("page") ? widget.book["page"] : 0;

      // 날짜 포맷 함수 (null 또는 빈 값을 처리)
String formatDate(String? dateStr) {
  if (dateStr != null && dateStr.isNotEmpty) {
    try {
      DateTime date = DateTime.parse(dateStr);
      print("Formatted Date: ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}");
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } catch (e) {
      print("Date parsing error: $e");
      return "-"; // 잘못된 날짜 형식일 경우
    }
  } else {
    return "-"; // 값이 null이거나 빈 값인 경우
  }
}



  // 독후감 탭 변수
  bool _isWriting = false;
  String _currentReport = '';
  bool _isEditing = false;
  final TextEditingController _controller = TextEditingController();

  void initState() {
    super.initState();
    _currentReport = ""; // 초기 값 설정 (리포트 데베에서 가져와야함 연동해서)
  }

  // 샘플 리뷰 데이터
  final List<Map<String, dynamic>> reviews = [
    {
      "username": "user1",
      "content": "이 책은 정말 유익하고 재미있었습니다!",
      "date": "2024-11-27",
      "rating": 5,
    },
    {
      "username": "user2",
      "content": "조금 지루한 부분도 있었지만, 전반적으로 괜찮았어요.",
      "date": "2024-11-26",
      "rating": 3,
    },
    {
      "username": "user3",
      "content": "글이 어렵지 않고 쉽게 읽을 수 있었습니다.",
      "date": "2024-11-25",
      "rating": 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '책 상세정보',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 126, 113, 159),
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // 뒤로 가기 버튼 비활성화
        toolbarHeight: 120.0,
        titleSpacing: 20.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 126, 113, 159),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 20.0, right: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar 밑줄
              Divider(
                  color: Color.fromARGB(255, 126, 113, 159), thickness: 0.5),
              SizedBox(height: 15),

              // 상단 섹션 (이미지, 제목, 저자, 출판연도)
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 책 이미지
                    Container(
                      width: 120,
                      height: 180,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // 그림자 색상
                            spreadRadius: 1, // 그림자 확산 범위
                            blurRadius: 5, // 그림자 흐림 정도
                            offset: Offset(0, 4), // 그림자의 위치 (x, y)
                          ),
                        ],
                      ),
                      // child: Image.asset(
                      //   //widget.book["image_path"],
                      //   widget.book["book_info"]?["Image"] ?? 'assets/images/default_image.jpg', // 기본 이미지 경로 추가
                      //   width: 120,
                      //   height: 160,
                      //   fit: BoxFit.cover,
                      //   errorBuilder: (context, error, stackTrace) {
                      //     return Icon(Icons.image,
                      //         size: 100, color: Colors.grey);
                      //   },
                      // ),
                      child: Image.asset(
                          widget.book["image_path"] ?? 'assets/images/default_image.png', // 기본 이미지 경로 지정
                          width: 120,
                          height: 160,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print("Error loading image: $error");
                            return Icon(Icons.image, size: 100, color: Colors.grey); // 오류 발생 시 기본 아이콘 표시
                          },
                        )

                    ),
                    SizedBox(width: 30),
                    // 제목, 저자, 출판연도 + 버튼
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.book["title"],
                            //widget.book["book_info"]?["title"] ?? 'No Title', // book_info에서 title을 가져오며, 값이 없으면 'No Title'로 처리
                            style: TextStyle(
                              color: Color.fromARGB(255, 126, 113, 159),
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "저자 | ${widget.book["author"]}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 126, 113, 159),
                                fontSize: 14),
                          ),
                          SizedBox(height: 60),
                          Row(
                            children: [
                              Text(
                                "${widget.book["publisher"]} | ${widget.book["publication_year"]}년 ${widget.book["publication_month"]}월",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB9AFD4),
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),

              // 상단 섹션 밑줄
              Divider(
                  color: Color.fromARGB(255, 126, 113, 159), thickness: 0.5),
              SizedBox(height: 16),

              // 시작일과 종료일 및 독서량 표시
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          //"시작일                         ${widget.startDay.isNotEmpty ? widget.startDay : ' - '}",
                          //"시작일                         ${widget.book.containsKey("start_date") ? widget.book["start_date"] : '-'}",
                          "시작일                         ${widget.book.containsKey("start_date") && widget.book["start_date"] != null ? formatDate(widget.book["start_date"]) : ' - '}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 126, 113, 159),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          //"종료일                         ${widget.endDay.isNotEmpty ? widget.endDay : ' - '}",
                          //"종료일                         ${widget.book.containsKey("end_date") ? widget.book["end_date"] : '-'}",
                          "종료일                         ${widget.book.containsKey("end_date") && widget.book["end_date"] != null ? formatDate(widget.book["end_date"]) : ' - '}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 126, 113, 159),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    // 독서량 표시 (CircularProgressIndicator)
                    Column(
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // 크기 키우기
                              SizedBox(
                                width: 65, // 원의 너비
                                height: 65, // 원의 높이
                                child: CircularProgressIndicator(
                                  value: totalPages > 0
                                      ? (readPages / totalPages)
                                          .clamp(0.0, 1.0) // 진행률 계산
                                      : 0.0, // 페이지 수가 0일 경우 0으로 설정
                                  // value: widget.book["page"] > 0
                                  //     ? (widget.readPages / widget.book["page"])
                                  //         .clamp(0.0,
                                  //             1.0) // 진행률 계산valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 126, 113, 159)), // 진행 색상
                                  //     : 0.0, // 페이지 수가 0일 경우 0으로 설정
                                  backgroundColor: Color.fromARGB(
                                      255, 214, 208, 232), // 배경 색상
                                  strokeWidth: 5.0, // 원형 바의 두께 증가
                                ),
                              ),
                              Text(
                                "${totalPages > 0 ? ((readPages / totalPages) * 100).clamp(0.0, 100.0).toInt() : 0}%", // 퍼센트를 텍스트로 표시
                                //"${widget.book["page"] > 0 ? ((widget.readPages / widget.book["page"]) * 100).clamp(0.0, 100.0).toInt() : 0}%", // 퍼센트를 텍스트로 표시
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 126, 113, 159),
                                ),
                              ),
                            ],
                          ),
                        ),
//                         Center(
//   child: Stack(
//     alignment: Alignment.center,
//     children: [
//       SizedBox(
//         width: 65,
//         height: 65,
//         child: CircularProgressIndicator(
//           value: totalPages > 0 ? (readPages / totalPages).clamp(0.0, 1.0) : 0.0,
//           backgroundColor: Color.fromARGB(255, 214, 208, 232),
//           strokeWidth: 5.0,
//         ),
//       ),
//       Text(
//         "${totalPages > 0 ? ((readPages / totalPages) * 100).clamp(0.0, 100.0).toInt() : 0}%",
//         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//       ),
//     ],
//   ),
// ),

                        SizedBox(height: 8),
                        // 추가된 텍스트
                        Text(
                          //"${widget.readPages}/${widget.book["page"]}p",
                          "$readPages/$totalPages p",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 126, 113, 159),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),

              // 세그먼트 바
              Container(
                margin:
                    EdgeInsets.symmetric(vertical: 16), // 세그먼트 바와 콘텐츠 사이 여백 추가
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
                      child: _buildSegment('상세정보', 0),
                    ),
                    Expanded(
                      child: _buildSegment('독후감', 1),
                    ),
                    Expanded(
                      child: _buildSegment('리뷰', 2),
                    ),
                  ],
                ),
              ),
              // 탭에 해당하는 내용
              _getTabContent(_currentTabIndex),
            ],
          ),
        ),
      ),
    );
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

  // 선택된 탭에 해당하는 콘텐츠를 반환하는 메소드
  Widget _getTabContent(int index) {
    switch (index) {
      case 0: // 상세정보 탭
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "${widget.book["description"]}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color.fromARGB(255, 126, 113, 159)),
          ),
        );
      case 1: // 독후감 탭
        return Container(
          width: 600, // 고정된 너비
          height: 330, // 고정된 높이
          padding: const EdgeInsets.only(
            left: 22.0,
            right: 20.0,
            top: 50.0,
          ), // 안쪽 여백
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 247, 241, 250),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                offset: Offset(4, 4),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 독후감이 작성되지 않은 경우 (빈 문자열일 때)
              if (_currentReport.isEmpty && !_isEditing)
                _buildEmptyReportUI()
              // 독후감이 작성된 경우
              else if (!_isEditing)
                _buildReportDisplayUI(),
              // 독후감 작성 상태일 때
              if (_isEditing) _buildWriteReportUI(),
            ],
          ),
        );
      case 2: // 리뷰 탭
        return Container(
          child: ReviewList(reviews: reviews), // ReviewList 위젯 호출
        );
      default:
        return Center(child: Text("잘못된 탭입니다."));
    }
  }

  // 독후감이 없을 때 "작성된 독후감이 없습니다." 메시지와 편집 버튼
  Widget _buildEmptyReportUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 편집 버튼을 오른쪽 상단에 배치
        Align(
          alignment: Alignment.topRight, // 오른쪽 상단으로 배치
          child: IconButton(
            onPressed: () {
              setState(() {
                _isEditing = true;
              });
            },
            icon: Icon(
              Icons.edit, // 편집 아이콘
              color: Color.fromARGB(255, 126, 113, 159),
            ),
          ),
        ),
        // 텍스트 중앙 배치
        SizedBox(
          height: 50,
        ),
        Center(
          child: Text(
            '작성된 독후감이 없습니다.',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 126, 113, 159),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWriteReportUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          maxLines: 7,
          decoration: InputDecoration(
            hintText: '독후감을 작성하세요...',
            filled: true, // 배경색 활성화
            fillColor: Color.fromARGB(255, 250, 248, 250), // 배경색 설정
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30), // 둥근 모서리
              borderSide: BorderSide.none, // 테두리 제거
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), // 둥근 모서리
              borderSide: BorderSide.none, // 비활성 상태 테두리 제거
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), // 둥근 모서리
              borderSide: BorderSide.none, // 포커스 상태 테두리 제거
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 15,
            ), // 입력 필드 여백 설정
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: _saveBookReport,
              child: Text('저장'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 126, 113, 159),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReportDisplayUI() {
    // TextPainter를 사용하여 텍스트가 차지하는 줄 수를 계산
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: _currentReport,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color.fromARGB(255, 126, 113, 159),
        ),
      ),
      maxLines: null, // 줄 수를 제한하지 않음
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
        maxWidth: MediaQuery.of(context).size.width - 32); // 최대 너비 설정

    int lineCount = textPainter.computeLineMetrics().length; // 텍스트가 차지하는 줄 수 계산

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 독후감 텍스트, 줄 수 계산 후 넘치면 ... 표시
        Text(
          _currentReport,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color.fromARGB(255, 126, 113, 159),
          ),
          overflow: TextOverflow.ellipsis, // 텍스트가 넘치면 "..." 표시
          maxLines: 9, // 9줄로 제한
        ),
        if (lineCount > 9) // 줄 수가 9줄을 초과하면
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookReportDetailPage(
                        userId: widget.userId,
                        bookId: widget.book["id"],
                      ),
                    ),
                  );
                },
                child: Text(
                  "+ 더보기",
                  style: TextStyle(
                    color: Color.fromARGB(255, 126, 113, 159),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  // text 저장 후 상태 변경 - 독후감 표시
  void _saveBookReport() {
    setState(() {
      _currentReport = _controller.text;
      _isEditing = false;
    });
  }
}