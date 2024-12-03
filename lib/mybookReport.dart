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

  // Firebase에서 데이터를 가져오는 함수
  Future<void> _fetchBookReports() async {
    try {
      final reportsSnapshot = await _databaseRef.child('reports').once();
      final booksSnapshot = await _databaseRef.child('books').once();

      if (reportsSnapshot.snapshot.value != null &&
          booksSnapshot.snapshot.value != null) {
        final reportsData =
            Map<String, dynamic>.from(reportsSnapshot.snapshot.value as Map);
        final booksData =
            Map<String, dynamic>.from(booksSnapshot.snapshot.value as Map);

        List<Map<String, dynamic>> loadedReports = [];

        reportsData.forEach((key, report) {
          final bookId = report['book_id'];
          final userId = report['user_id'];
          final userReport = report['report'];

          if (booksData.containsKey(bookId)) {
            final book = booksData[bookId];
            final DateTime publicationDate =
                DateTime.fromMillisecondsSinceEpoch(
                    book['publication_date'] * 1000);

            loadedReports.add({
              'userId': userId,
              'bookId': bookId,
              'title': book['title'],
              'author': book['author'],
              'bookReport': userReport,
              'image': book['image_path'],
              'publisher': book['publisher'],
              'publishYear': publicationDate.year.toString(),
              'publishMonth': publicationDate.month.toString(),
            });
          }
        });

        setState(() {
          bookReports = loadedReports;
        });
      }
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
          '나의 독후감',
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
      body: bookReports.isEmpty
          ? Center(child: CircularProgressIndicator())
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
                    IconButton(
                      icon: Icon(Icons.more_vert),
                      color: Colors.black,
                      onPressed: () {
                        _showMoreOptions(context, index);
                      },
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

  // 플로팅 메뉴를 표시하는 함수
  void _showMoreOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit, color: Colors.blue),
                title: Text('수정', style: TextStyle(color: Colors.blue)),
                onTap: () {
                  Navigator.pop(context); // 메뉴 닫기
                  _showEditReviewDialog(context, index);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('삭제', style: TextStyle(color: Colors.red)),
                onTap: () {
                  setState(() {
                    bookReports.removeAt(index); // 삭제
                  });
                  Navigator.pop(context); // 메뉴 닫기
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 독후감 수정 창을 띄우는 함수
  void _showEditReviewDialog(BuildContext context, int index) {
    TextEditingController _bookReportController = TextEditingController();
    _bookReportController.text = bookReports[index]['bookReport'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('독후감 수정'),
          content: TextField(
            controller: _bookReportController,
            maxLines: 3,
            decoration: InputDecoration(hintText: "독후감을 수정하세요."),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 취소
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // 수정된 독후감을 저장
                  bookReports[index]['bookReport'] = _bookReportController.text;
                });
                Navigator.pop(context); // 수정 완료 후 다이얼로그 닫기
              },
              child: Text('수정'),
            ),
          ],
        );
      },
    );
  }
}
