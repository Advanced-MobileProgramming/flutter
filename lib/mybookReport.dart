import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'bookReportDetail.dart'; // 독후감 상세 페이지

class BookReportPage extends StatefulWidget {
  @override
  _BookReportPageState createState() => _BookReportPageState();
}

class _BookReportPageState extends State<BookReportPage> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> bookReports = []; // 독후감 데이터를 저장할 리스트

  @override
  void initState() {
    super.initState();
    _fetchBookReports(); // Firebase 데이터 가져오기
  }

  Future<void> _fetchBookReports() async {
  try {
    print("Fetching bookReports and books from Firebase...");
    final reportsSnapshot = await _databaseRef.child('bookReports').once();
    final booksSnapshot = await _databaseRef.child('books').once();

    print("Reports Snapshot: ${reportsSnapshot.snapshot.value}");
    print("Books Snapshot: ${booksSnapshot.snapshot.value}");

    if (reportsSnapshot.snapshot.value != null &&
        booksSnapshot.snapshot.value != null) {
      final reportsData =
          Map<String, dynamic>.from(reportsSnapshot.snapshot.value as Map);
      final booksData =
          Map<String, dynamic>.from(booksSnapshot.snapshot.value as Map);

      print("Parsed Reports Data: $reportsData");
      print("Parsed Books Data: $booksData");

      List<Map<String, dynamic>> loadedReports = [];

      reportsData.forEach((userId, userReports) {
        final userReportsMap =
            Map<String, dynamic>.from(userReports as Map); // 사용자별 데이터 처리
        userReportsMap.forEach((bookId, report) {
          final previousBookId = (int.parse(bookId) - 1).toString(); // bookId -1 계산
          if (booksData.containsKey(previousBookId)) {
            final book = booksData[previousBookId];
            final DateTime publicationDate =
                DateTime.fromMillisecondsSinceEpoch(
                    book['publication_date'] * 1000);

            print("Book matched for bookId: $bookId");

            loadedReports.add({
              'userId': userId,
              'bookId': bookId,
              'title': book['title'],
              'author': book['author'],
              'bookReport': report['content'], // content 필드
              'image': book['image_path'],
              'publisher': book['publisher'],
              'publishYear': publicationDate.year.toString(),
              'publishMonth': publicationDate.month.toString(),
            });
          } else {
            print("No matching book found for bookId: $bookId");
          }
        });
      });

      print("Loaded Reports: $loadedReports");

      setState(() {
        bookReports = loadedReports;
      });
    } else {
      print("No data found in bookReports or books.");
    }
  } catch (e) {
    print("Error fetching data: $e");
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text("데이터를 불러오는 중 오류가 발생했습니다: $e")),
    // );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '나의 독후감',
          style: TextStyle(
              fontSize: 30, color: Color.fromARGB(255, 126, 113, 159)),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        toolbarHeight: 120.0,
        titleSpacing: 20.0,
      ),
      body: bookReports.isEmpty
          ? Center(
              child: Text(
                '독후감이 없습니다.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  for (var i = 0; i < bookReports.length; i++) ...[
                    _buildBookCard(
                      bookReports[i]['title'],
                      bookReports[i]['author'],
                      Color.fromARGB(235, 234, 229, 239),
                      Color.fromARGB(255, 126, 113, 159),
                      bookReports[i]['bookReport'],
                      bookReports[i]['publisher'],
                      bookReports[i]['publishYear'],
                      bookReports[i]['publishMonth'],
                      bookReports[i]['image'],
                      bookReports[i]['userId'],
                      bookReports[i]['bookId'],
                      i,
                    ),
                    if (i < bookReports.length - 1) SizedBox(height: 16),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildBookCard(
      String title,
      String author,
      Color backgroundColor,
      Color textColor,
      String bookReport,
      String publisher,
      String publishYear,
      String publishMonth,
      String image,
      String userId,
      String bookId,
      int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookReportDetailPage(
              userId: userId,
              bookId: bookId,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // 둥근 모서리
        ),
        elevation: 4, // 그림자 효과
        margin: EdgeInsets.symmetric(horizontal: 16.0), // 카드 간 간격
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            height: 140, // 카드 높이를 설정
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽에 정렬
                  children: [
                    Text(
                      '$title / $author',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '"$bookReport"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}