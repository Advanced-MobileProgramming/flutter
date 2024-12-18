import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // 사용 안할 시 삭제
import 'package:soobook/bookReportDetail.dart';
import 'package:soobook/reviewList.dart';
import 'package:soobook/addBook.dart';

class BookDetail extends StatefulWidget {
  final String userId;
  final int bookId;
  final String nickname;

  BookDetail(
      {required this.userId, required this.bookId, required this.nickname});

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  Map<String, dynamic> book = {};
  bool _isLoading = true; // 로딩 상태를 관리하는 변수 추가
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _checkBookState(); // 비동기 작업 시작
    fetchBook();
    fetchCurrentPage(); // current_page 가져오기
  }

  // Firebase에서 책 데이터 가져오기
  Future<void> fetchBook() async {
    final adjustedBookId = (widget.bookId - 1).toString(); // ID 변환
    final DatabaseReference booksRef =
        FirebaseDatabase.instance.ref("books").child(adjustedBookId);

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
    final DatabaseReference bookcasesRef =
        FirebaseDatabase.instance.ref("bookcases");

    try {
      Map<String, dynamic> bookcaseData = {
        "user_id": userId,
        "book_id": bookId.toString(),
        "book_info": bookInfo, // 책 정보 전체 저장
        "start_date": startDate?.toIso8601String() ?? "", // null인 경우 빈 문자열 처리
        "end_date": endDate?.toIso8601String() ?? "", // null인 경우 빈 문자열 처리
        "current_page": currentPage, // 현재 페이지 저장
        "reading_status": readingStatus, // 읽기 상태 저장
        "collection_name": collectionName, // 선택한 컬렉션 이름 저장
      };

      await bookcasesRef
          .child(userId)
          .child(bookId.toString())
          .set(bookcaseData);
      print("책 정보가 성공적으로 저장되었습니다.");
    } catch (e) {
      print("책 정보 저장 오류: $e");
    }
  }

  Future<void> fetchCurrentPage() async {
    try {
      final bookRef = FirebaseDatabase.instance
          .ref("bookcases/${widget.userId}/${widget.bookId}");
      print(
          "Fetching current page from path: bookcases/${widget.userId}/${widget.bookId}");

      final snapshot = await bookRef.get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        print("Data fetched from bookcases: $data");

        if (data.containsKey("current_page")) {
          setState(() {
            currentPage = data["current_page"];
          });
        } else {
          setState(() {
            //currentPage = 0; // current_page 값이 없을 경우 0으로 설정
          });
        }
      } else {
        print("No data found in bookcases for current page.");
        setState(() {
          currentPage = 0; // 데이터가 없을 경우 0으로 설정
        });
      }
    } catch (error) {
      print("Error fetching current page: $error");
      setState(() {
        currentPage = 0; // 오류 발생 시 0으로 설정
      });
    }
  }

  Future<void> _checkBookState() async {
    try {
      print(
          "Checking if book is stored for user: ${widget.userId}, bookId: ${widget.bookId}");
      final isStored = await isItStored(widget.userId, widget.bookId);

      if (isStored) {
        print("Book is already stored. Navigating to StoredBookDetail.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StoredBookDetail(
              userId: widget.userId,
              book: book,
              bookId: widget.bookId,
              nickname: widget.nickname,
            ),
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
              nickname: widget.nickname,
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
  final String nickname;

  UnstoredBookDetail(
      {required this.userId,
      required this.book,
      required this.bookId,
      required this.nickname});

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

  void addToBookcases({
    required String userId,
    required int bookId,
    required Map<String, dynamic> bookInfo,
    required DateTime? startDate,
    required DateTime? endDate,
    //required int currentPage,
    required String readingStatus,
    required String collectionName,
  }) async {
    final DatabaseReference bookcasesRef =
        FirebaseDatabase.instance.ref("bookcases");

    try {
      Map<String, dynamic> bookcaseData = {
        "user_id": userId,
        "book_id": bookId.toString(),
        "book_info": bookInfo, // 책 정보 전체 저장
        "start_date": startDate?.toIso8601String() ?? "", // null인 경우 빈 문자열 처리
        "end_date": endDate?.toIso8601String() ?? "", // null인 경우 빈 문자열 처리
        "reading_status": readingStatus, // 읽기 상태 저장
        "collection_name": collectionName, // 선택한 컬렉션 이름 저장
      };

      await bookcasesRef
          .child(userId)
          .child(bookId.toString())
          .set(bookcaseData);
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
                              IconButton(
                                icon: Icon(Icons.add_circle,
                                    color: Color.fromARGB(255, 126, 113, 159),
                                    size: 45),
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
                                    startDate: startDate ??
                                        DateTime.now(), // null이면 현재 시간 사용
                                    //endDate: endDate ?? DateTime.now().add(Duration(days: 7)), // null이면 7일 후로 설정
                                    endDate: null, // 종료일 기본값 제거
                                    //currentPage: currentPage,
                                    readingStatus: readingStatus,
                                    collectionName: collectionName,
                                  );

                                  // 저장 완료 메시지
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(
                                  //       content: Text("책이 책장에 기본값으로 추가되었습니다.")),
                                  // );

                                  // 모달 열기
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      //return AddBook(userId: widget.userId, book: widget.book,);
                                      // Fetch the readingStatus from the book data
                                      String readingStatus =
                                          widget.book["reading_status"] ??
                                              "읽기 전";
                                      int selectedTabIndex = 0;
                                      if (readingStatus == "읽는 중") {
                                        selectedTabIndex = 1;
                                      } else if (readingStatus == "완료") {
                                        selectedTabIndex = 2;
                                      }

                                      // Return the AddBook widget with the required parameters
                                      return AddBook(
                                        userId: widget.userId,
                                        book: widget.book,
                                        readingStatus: readingStatus,
                                        selectedTabIndex: selectedTabIndex,
                                        bookId: widget
                                            .bookId, // Pass the selectedTabIndex
                                      );
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
    return ReviewList(
      book: widget.book,
      userId: widget.userId,
      nickname: widget.nickname,
    ); // ReviewList 위젯 호출
  }
}

// 저장된 책 상태
class StoredBookDetail extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> book;
  final int? bookId; // bookId를 추가합니다.
  final String nickname;

  StoredBookDetail(
      {required this.userId,
      required this.book,
      required this.bookId,
      required this.nickname});

  @override
  _StoredBookDetailState createState() => _StoredBookDetailState();
}

class _StoredBookDetailState extends State<StoredBookDetail> {
  int _currentTabIndex = 0; // 세그먼트 바 초기값
  int currentPage = 0; // 현재 페이지 상태 변수
  int totalPages = 0; // 전체 페이지 상태 변수
  bool isLoading = true; // 데이터 로딩 상태
  DateTime? startDate; // 시작일 상태 변수
  DateTime? endDate; // 종료일 상태 변수

  @override
  void initState() {
    super.initState();
    fetchCurrentPage(); // 화면 로드 시 Firebase에서 데이터 로드
    _fetchBookReport();
  }

  Future<void> fetchCurrentPage() async {
    try {
      // Firebase 경로 확인
      final bookRef = FirebaseDatabase.instance
          .ref("bookcases/${widget.userId}/${widget.bookId}");
      print(
          "Fetching data from path: bookcases/${widget.userId}/${widget.bookId}");

      final snapshot = await bookRef.get();

      if (snapshot.exists) {
        // 데이터 확인
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        print("Data fetched: $data");

        if (data.containsKey("book_info")) {
          final bookInfo = Map<String, dynamic>.from(data["book_info"]);
          print("book_info: $bookInfo");

          setState(() {
            currentPage = data.containsKey("current_page")
                ? data["current_page"]
                : 0; // 현재 페이지
            totalPages =
                bookInfo.containsKey("page") ? bookInfo["page"] : 0; // 전체 페이지
            startDate =
                data.containsKey("start_date") && data["start_date"] != null
                    ? DateTime.parse(data["start_date"])
                    : null;
            endDate = data.containsKey("end_date") && data["end_date"] != null
                ? DateTime.parse(data["end_date"])
                : null;
            isLoading = false; // 로딩 상태 해제
          });
        } else {
          print("No book_info found in data.");
          setState(() {
            totalPages = 0;
            isLoading = false;
          });
        }
      } else {
        print("No data found for this book.");
        setState(() {
          totalPages = 0;
          isLoading = false;
        });
      }
    } catch (error) {
      print("Error fetching current page: $error");
      setState(() {
        isLoading = false; // 로딩 상태 해제
      });
    }
  }

  Future<void> _fetchBookReport() async {
    try {
      final DatabaseReference bookReportsRef = FirebaseDatabase.instance
          .ref("bookReports/${widget.userId}/${widget.bookId}");

      final snapshot = await bookReportsRef.get();

      if (snapshot.exists) {
        final reportData = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          _currentReport = reportData["content"] ?? ""; // 독후감 내용
          _isEditing = false; // 수정 상태 초기화
        });
      } else {
        setState(() {
          _currentReport = ""; // 독후감이 없을 경우 빈 값 설정
        });
      }
    } catch (e) {
      print("Error fetching book report: $e");
      setState(() {
        _currentReport = ""; // 오류 시 빈 값으로 설정
      });
    }
  }

  void updateCurrentPage(int currentPage) async {
    final DatabaseReference bookcasesRef =
        FirebaseDatabase.instance.ref("bookcases");

    try {
      // Firebase에 current_page 업데이트
      await bookcasesRef
          .child(widget.userId)
          .child(widget.bookId.toString())
          .update({"current_page": currentPage});
      print("Current page updated in Firebase: $currentPage");

      // Firebase에서 기존 reading_status 가져오기
      final snapshot = await bookcasesRef
          .child(widget.userId)
          .child(widget.bookId.toString())
          .get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final String currentStatus = data["reading_status"] ?? "읽기 전";
        final int totalPages = data["book_info"]?["page"] ?? 0;

        // 읽기 전 -> 읽는 중으로 상태 변경
        if (currentPage > 0 &&
            currentPage < totalPages &&
            currentStatus != "읽는 중") {
          await bookcasesRef
              .child(widget.userId)
              .child(widget.bookId.toString())
              .update({"reading_status": "읽는 중"});
          print("Reading status updated to '읽는 중'.");
        }

        // 읽는 중 -> 완료로 상태 변경
        if (currentPage == totalPages && currentStatus != "완료") {
          await bookcasesRef
              .child(widget.userId)
              .child(widget.bookId.toString())
              .update({"reading_status": "완료"});
          print("Reading status updated to '완료'.");
        }

        // current_page가 0이면 읽기 전 상태로 복귀
        if (currentPage == 0 && currentStatus != "읽기 전") {
          await bookcasesRef
              .child(widget.userId)
              .child(widget.bookId.toString())
              .update({"reading_status": "읽기 전"});
          print("Reading status updated to '읽기 전'.");
        }
      }
    } catch (e) {
      print("Error updating current page or reading status: $e");
    }
  }

  Future<int> getCurrentPage() async {
    final bookRef = FirebaseDatabase.instance
        .ref("bookcases/${widget.userId}/${widget.bookId}"); // Firebase 참조 생성

    try {
      final snapshot = await bookRef.get(); // 비동기 호출 대기
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        if (data.containsKey("current_page")) {
          final int page = data["current_page"]; // current_page 값을 가져옴
          print("Current Page: $page"); // 로그 출력
          return page; // 값을 반환
        } else {
          print("current_page key not found"); // 키가 없을 경우 로그
          return 0; // 기본값 반환
        }
      } else {
        print("No data found for this book"); // 데이터가 없을 경우 로그
        return 0; // 기본값 반환
      }
    } catch (error) {
      print("Error fetching current_page: $error"); // 오류 처리
      return 0; // 기본값 반환
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // 독후감 탭 변수
  bool _isWriting = false;
  String _currentReport = '';
  bool _isEditing = false;
  final TextEditingController _controller = TextEditingController();

  // void initState() {
  //   super.initState();
  //   _currentReport = ""; // 초기 값 설정 (리포트 데베에서 가져와야함 연동해서)
  // }

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
                        child: Image.asset(
                          widget.book["image_path"] ??
                              'assets/images/default_image.png', // 기본 이미지 경로 지정
                          width: 120,
                          height: 160,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print("Error loading image: $error");
                            return Icon(Icons.image,
                                size: 100,
                                color: Colors.grey); // 오류 발생 시 기본 아이콘 표시
                          },
                        )),
                    SizedBox(width: 30),
                    // 제목, 저자, 출판연도 + 버튼
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.book["title"],
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
                        GestureDetector(
                          onTap: () async {
                            final DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: startDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                startDate = selectedDate;
                              });

                              // Firebase 업데이트
                              final DatabaseReference bookRef =
                                  FirebaseDatabase.instance.ref(
                                      "bookcases/${widget.userId}/${widget.bookId}");
                              try {
                                await bookRef.update({
                                  "start_date": selectedDate.toIso8601String(),
                                });
                                print(
                                    "Start date updated in Firebase: ${selectedDate.toIso8601String()}");
                                // 로컬 상태 업데이트
                                setState(() {
                                  widget.book["start_date"] = selectedDate;
                                });
                              } catch (e) {
                                print("Error updating start date: $e");
                              }
                            }
                          },
                          child: Text(
                            "시작일                         ${formatDate(startDate)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 126, 113, 159),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            final DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: endDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                endDate = selectedDate;
                              });

                              // Firebase 업데이트
                              final DatabaseReference bookRef =
                                  FirebaseDatabase.instance.ref(
                                      "bookcases/${widget.userId}/${widget.bookId}");
                              try {
                                await bookRef.update({
                                  "end_date": selectedDate.toIso8601String(),
                                  "reading_status": "완료"
                                });
                                print(
                                    "End date updated in Firebase: ${selectedDate.toIso8601String()}");
                                // 로컬 상태 업데이트
                                setState(() {
                                  widget.book["end_date"] = selectedDate;
                                  widget.book["reading_status"] = "완료";
                                });
                              } catch (e) {
                                print("Error updating end date: $e");
                              }
                            }
                          },
                          child: Text(
                            "종료일                         ${formatDate(endDate)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 126, 113, 159),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // 독서량 표시 (CircularProgressIndicator)
                    Column(
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  // DB에서 reading_status 가져오기
                                  //String readingStatus = widget.book["book_info"]["reading_status"] ?? "읽기 전";
                                  String readingStatus =
                                      widget.book["reading_status"] ?? "읽기 전";

                                  int currentPage =
                                      widget.book["current_page"] ?? 0;
                                  int totalPages =
                                      widget.book["total_pages"] ?? 0;

                                  // reading_status 값에 따라 탭 선택 (읽기 중일 경우 1번 탭 선택)
                                  int selectedTabIndex = 0;
                                  if (readingStatus == "읽는 중") {
                                    selectedTabIndex = 1;
                                  } else if (readingStatus == "완료") {
                                    selectedTabIndex = 2;
                                  }

                                  // AddBook에 selectedTabIndex와 함께 reading_status를 전달
                                  return AddBook(
                                    userId: widget.userId,
                                    book: widget.book,
                                    readingStatus: readingStatus,
                                    selectedTabIndex: selectedTabIndex,
                                    bookId: widget.bookId, // 탭 인덱스 전달
                                  );
                                },
                              );
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // 크기 키우기
                                SizedBox(
                                  width: 65, // 원의 너비
                                  height: 65, // 원의 높이
                                  child: CircularProgressIndicator(
                                    value: totalPages > 0
                                        ? (currentPage / totalPages)
                                            .clamp(0.0, 1.0) // 진행률 계산
                                        : 0.0, // 페이지 수가 0일 경우 0으로 설정
                                    backgroundColor: Color.fromARGB(
                                        255, 214, 208, 232), // 배경 색상
                                    strokeWidth: 5.0, // 원형 바의 두께 증가
                                  ),
                                ),
                                Text(
                                  "${totalPages > 0 ? ((currentPage / totalPages) * 100).toInt() : 0}%", // 진행 퍼센트 표시
                                  //"$currentPage / ${widget.book.containsKey('page') ? widget.book['page'] : 0} p",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 126, 113, 159),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        // 추가된 텍스트
                        Text(
                          //"${widget.readPages}/${widget.book["page"]}p",
                          "$currentPage /$totalPages p",
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
            top: 20.0,
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
          child: ReviewList(
            book: widget.book,
            userId: widget.userId,
            nickname: widget.nickname,
          ), // ReviewList 위젯 호출
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
        // 텍스트를 아래로 내리기 위해 SizedBox 추가
        SizedBox(height: 80), // 80만큼 여백을 두어 아래로 내려줌
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
      maxWidth: MediaQuery.of(context).size.width - 32, // 최대 너비 설정
    );

    int lineCount = textPainter.computeLineMetrics().length; // 텍스트가 차지하는 줄 수 계산

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 점 3개 버튼을 Column 위에 배치하고, 위쪽으로 조금 올리기
        if (_currentReport.isNotEmpty && !_isEditing)
          Padding(
            padding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.more_vert), // 점 3개 버튼
                onPressed: () {
                  _showMoreOptions(context); // 더보기 버튼 클릭 시 행동
                },
              ),
            ),
          ),

        // 독후감 수정 UI (TextField가 활성화된 상태일 때)
        if (_isEditing)
          Padding(
            padding: const EdgeInsets.only(top: 8.0), // 텍스트 필드 위쪽 여백
            child: TextField(
              controller: _controller, // 텍스트 컨트롤러 연결
              autofocus: true, // 자동으로 포커스를 설정
              maxLines: 7, // 최대 줄 수
              decoration: InputDecoration(
                hintText: '독후감을 수정하세요...',
                filled: true, // 배경색 활성화
                fillColor: Color.fromARGB(255, 250, 248, 250), // 배경색 설정
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // 둥근 모서리
                  borderSide: BorderSide.none, // 테두리 제거
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none, // 비활성 상태 테두리 제거
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none, // 포커스 상태 테두리 제거
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 15,
                ),
              ),
              onChanged: (newText) {
                setState(() {
                  _currentReport = newText; // 텍스트 변경 시 저장
                });
              },
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              _currentReport.isNotEmpty
                  ? _currentReport
                  : "작성된 독후감이 없습니다.", // 독후감이 없을 때 메시지 표시
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color.fromARGB(255, 126, 113, 159),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 9, // 9줄로 제한
            ),
          ),

        // 9줄을 초과하면 더보기 버튼을 표시
        if (lineCount > 9)
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
                        bookId:
                            widget.book["id"].toString(), // int를 String으로 변환
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

// 독후감 수정 다이얼로그 옵션
  void _showMoreOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('수정'),
                onTap: () {
                  // 수정 버튼 클릭 시 _isEditing을 true로 설정하여 수정 가능하도록 함
                  setState(() {
                    _isEditing = true;
                    _controller.text = _currentReport; // 현재 독후감 내용 불러오기
                  });
                  Navigator.pop(context); // 다이얼로그 닫기
                },
              ),
              ListTile(
                title: Text('삭제'),
                onTap: () async {
                  // 삭제 로직
                  try {
                    final DatabaseReference bookReportsRef =
                        FirebaseDatabase.instance.ref(
                            "bookReports/${widget.userId}/${widget.book["id"]}");

                    // Firebase에서 독후감 삭제
                    await bookReportsRef.remove();
                    print("독후감이 성공적으로 삭제되었습니다.");

                    // UI 상태 초기화
                    setState(() {
                      _currentReport = ''; // 독후감 내용 초기화
                      _isEditing = false; // 수정 상태 해제
                    });

                    // 삭제 성공 메시지
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(content: Text("독후감이 성공적으로 삭제되었습니다!")),
                    // );
                  } catch (e) {
                    print("Error deleting book report: $e");
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(content: Text("독후감 삭제에 실패했습니다.")),
                    // );
                  }
                  Navigator.pop(context); // 다이얼로그 닫기
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 수정된 코드
  void _saveBookReport() async {
    try {
      final DatabaseReference bookReportsRef = FirebaseDatabase.instance
          .ref("bookReports/${widget.userId}/${widget.bookId}");

      // Firebase에 독후감 저장
      await bookReportsRef.set({
        "content": _controller.text,
        //"updatedAt": DateTime.now().toIso8601String(), // 수정 시간 기록
      });

      // 로컬 상태 업데이트
      setState(() {
        _currentReport = _controller.text; // 저장된 텍스트
        _isEditing = false; // 수정 상태 해제
      });

      // 저장 성공 메시지
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("독후감이 성공적으로 저장되었습니다!")),
      // );
    } catch (e) {
      print("Error saving book report: $e");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("독후감 저장에 실패했습니다.")),
      // );
    }
  }
}
