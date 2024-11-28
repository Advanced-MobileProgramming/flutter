import 'package:flutter/material.dart';
import 'bookReportDetail.dart'; // 새로운 파일을 import

class BookReportPage extends StatefulWidget {
  @override
  _BookReportPageState createState() => _BookReportPageState();
}

class _BookReportPageState extends State<BookReportPage> {
  // 독후감 데이터 리스트
  List<Map<String, dynamic>> bookReports = [
    {'title': '책 제목 1', 'author': '저자 1', 'bookReport': '이 책은 정말 훌륭했습니다.'},
    {
      'title': '책 제목 2',
      'author': '저자 2',
      'bookReport': '좋은 책이었지만 아쉬운 점이 많았어요.'
    },
    {'title': '책 제목 3', 'author': '저자 3', 'bookReport': '정말 추천하는 책입니다!'},
    {'title': '책 제목 4', 'author': '저자 4', 'bookReport': '정말 추천하는 책입니다!'},
    {'title': '책 제목 5', 'author': '저자 5', 'bookReport': '정말 추천하는 책입니다!'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 독후감',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 126, 113, 159))),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        toolbarHeight: 120.0,
        titleSpacing: 20.0,
      ),
      body: SingleChildScrollView(
        // 스크롤 가능한 영역
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20), // 상단 여백
            // 카드들 사이에 간격 추가
            for (var i = 0; i < bookReports.length; i++) ...[
              _buildBookCard(
                bookReports[i]['title'],
                bookReports[i]['author'],
                Color.fromARGB(235, 234, 229, 239),
                Color.fromARGB(255, 126, 113, 159),
                bookReports[i]['bookReport'],
                i,
              ),
              // 각 카드 사이에 16px 간격 추가
              if (i < bookReports.length - 1) SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(String title, String author, Color backgroundColor,
      Color textColor, String bookReport, int index) {
    return GestureDetector(
      onTap: () {
        // 카드 클릭 시 독후감 전체 내용을 보여주는 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookReportDetailPage(
              title: title,
              author: author,
              bookReport: bookReport,
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
                    // 왼쪽에 책 제목과 저자
                    Text(
                      '$title / $author',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    // 오른쪽에 점 3개 버튼
                    IconButton(
                      icon: Icon(Icons.more_vert),
                      color: Colors.black,
                      onPressed: () {
                        // 점 3개 버튼 클릭 시 플로팅 메뉴 표시
                        _showMoreOptions(context, index);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16), // 제목, 저자, 버튼과 리뷰 간 간격
                // 리뷰 텍스트 중앙 정렬
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '"$bookReport"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                    ),
                    maxLines: 2, // 최대 2줄로 제한
                    overflow: TextOverflow.ellipsis, // 넘칠 경우 "..." 표시
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
                  // 수정 클릭 시 독후감 수정하는 창 띄우기
                  Navigator.pop(context); // 메뉴 닫기
                  _showEditReviewDialog(context, index);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('삭제', style: TextStyle(color: Colors.red)),
                onTap: () {
                  print('삭제 클릭됨');
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
