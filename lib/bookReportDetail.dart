import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class BookReportDetailPage extends StatefulWidget {
  final String userId;
  final String bookId;

  BookReportDetailPage({
    required this.userId,
    required this.bookId,
  });

  @override
  _BookReportDetailPageState createState() => _BookReportDetailPageState();
}

class _BookReportDetailPageState extends State<BookReportDetailPage> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  String? report; // 독후감
  Map<String, dynamic>? bookDetails; // 책 정보
  String? publicationYear;
  String? publicationMonth;

  @override
  void initState() {
    super.initState();
    _fetchReportAndBookDetails();
  }

  // reports와 books 테이블에서 데이터를 가져오는 함수
  Future<void> _fetchReportAndBookDetails() async {
    try {
      // reports 테이블에서 report 가져오기
      final reportSnapshot = await _databaseRef
          .child("reports")
          .orderByChild("user_id")
          .equalTo(widget.userId)
          .once();

      String? fetchedReport;

      if (reportSnapshot.snapshot.value != null) {
        final reportsData =
            Map<String, dynamic>.from(reportSnapshot.snapshot.value as Map);
        reportsData.forEach((key, value) {
          if (value["book_id"] == widget.bookId) {
            fetchedReport = value["report"];
          }
        });
      }

      // books 테이블에서 book 정보 가져오기
      final bookSnapshot =
          await _databaseRef.child("books").child(widget.bookId).once();
      Map<String, dynamic>? fetchedBookDetails;

      if (bookSnapshot.snapshot.value != null) {
        fetchedBookDetails =
            Map<String, dynamic>.from(bookSnapshot.snapshot.value as Map);

        // publication_date 처리
        final int timestamp = fetchedBookDetails["publication_date"];
        final DateTime date =
            DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        publicationYear = date.year.toString();
        publicationMonth = date.month.toString();
      }

      // 상태 업데이트
      setState(() {
        report = fetchedReport;
        bookDetails = fetchedBookDetails;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("데이터를 불러오는 중 오류가 발생했습니다: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '독후감 상세',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 126, 113, 159)),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        toolbarHeight: 120.0,
        titleSpacing: 20.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 20.0, right: 16.0),
        child: SingleChildScrollView(
          child: bookDetails == null || report == null
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AppBar 밑줄
                    Divider(
                        color: Color.fromARGB(255, 126, 113, 159),
                        thickness: 0.5),
                    SizedBox(height: 15),
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
                                  color:
                                      Colors.black.withOpacity(0.2), // 그림자 색상
                                  spreadRadius: 1, // 그림자 확산 범위
                                  blurRadius: 5, // 그림자 흐림 정도
                                  offset: Offset(0, 4), // 그림자의 위치 (x, y)
                                ),
                              ],
                            ),
                            child: Image.network(
                              bookDetails!["image_path"],
                              width: 120,
                              height: 160,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.image,
                                    size: 100, color: Colors.grey);
                              },
                            ),
                          ),
                          SizedBox(width: 30),
                          // 제목, 저자, 출판연도
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bookDetails!["title"],
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
                                  "저자 | ${bookDetails!["author"]}",
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
                                      "${bookDetails!["publisher"]} | ${publicationYear}년 ${publicationMonth}월",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFB9AFD4),
                                        fontSize: 14,
                                      ),
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
                    Divider(
                        color: Color.fromARGB(255, 126, 113, 159),
                        thickness: 0.5),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 50.0, bottom: 50.0),
                      child: Text(
                        report ?? "독후감이 없습니다.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 126, 113, 159),
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
