import 'package:flutter/material.dart';
import 'package:soobook/allBooks.dart';
import 'package:soobook/bookShelf.dart';
import 'package:soobook/myHome.dart'; // HomePage가 필요하다면 임포트
import 'package:soobook/login.dart'; // 로그인 페이지 임포트
import 'package:soobook/profileEdit.dart';
import 'package:soobook/mybookReport.dart';
import 'package:soobook/myReview.dart';

class MyPage extends StatefulWidget {
  final String nickname;
  MyPage({required this.nickname});
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(nickname: widget.nickname)), // 수정 필요
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BookshelfPage(nickname: widget.nickname)),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AllBooksPage(nickname: widget.nickname)),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyPage(
                  nickname: widget.nickname,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 126, 113, 159))),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 120.0,
        titleSpacing: 20.0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // 프로필 사진이 포함된 FloatingActionButton
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
              child: SizedBox(
                width: 400, // 원하는 너비
                height: 180, // 원하는 높이
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileEditPage(
                          nickname: widget.nickname,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      // 프로필 사진
                      CircleAvatar(
                        radius: 50, // 이미지 크기
                        backgroundImage: AssetImage('image/DefaultProfile.png'),
                        backgroundColor: Colors.transparent, // 배경색 제거
                      ),
                      SizedBox(width: 10), // 프로필 사진과 텍스트 사이의 간격
                      // 유저 닉네임과 유저 ID를 포함한 Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                        children: [
                          // 유저 닉네임
                          Text(
                            '${widget.nickname}', // 여기에 실제 유저 닉네임을 넣으세요
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color:
                                  Color.fromARGB(235, 126, 113, 159), // 닉네임 색상
                            ),
                          ),
                          // 유저 ID
                          Text(
                            '@${widget.nickname}', // 여기에 실제 유저 id를 넣으세요
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  Color.fromARGB(235, 126, 113, 159), // ID 색상
                            ),
                          ),
                        ],
                      ),
                      Spacer(), // 화살표 아이콘을 오른쪽 끝으로 배치하기 위해 사용
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileEditPage(
                                nickname: widget.nickname,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  backgroundColor:
                      Color.fromARGB(235, 234, 229, 239), // FAB 배경색
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                children: [
                  Divider(color: Color.fromARGB(255, 126, 113, 159)),
                  ListTile(
                    leading: Icon(Icons.library_books, color: Colors.black),
                    title: Text('독후감 관리',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {
                      // 독후감 관리 버튼 클릭 시 bookReport.dart로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookReportPage(),
                        ),
                      );
                    },
                  ),
                  Divider(color: Color.fromARGB(255, 126, 113, 159)),
                  ListTile(
                    leading: Icon(Icons.rate_review, color: Colors.black),
                    title: Text('나의 리뷰',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {
                      // 내가 쓴 리뷰 버튼 클릭 시 myReview.dart로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyReviewPage(),
                        ),
                      );
                    },
                  ),
                  Divider(color: Color.fromARGB(255, 126, 113, 159)),
                  ListTile(
                    leading: Icon(Icons.question_answer, color: Colors.black),
                    title: Text('의견 보내기',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('의견 보내기 페이지로 이동')),
                      );
                    },
                  ),
                  Divider(color: Color.fromARGB(255, 126, 113, 159)),
                  ListTile(
                    leading: Icon(Icons.update, color: Colors.black),
                    title: Text('업데이트',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('업데이트 페이지로 이동')),
                      );
                    },
                  ),
                  Divider(color: Color.fromARGB(255, 126, 113, 159)),
                  ListTile(
                    leading: Icon(Icons.help_outline, color: Colors.black),
                    title: Text('이용약관',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('이용약관 페이지로 이동')),
                      );
                    },
                  ),
                  Divider(color: Color.fromARGB(255, 126, 113, 159)),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.black),
                    title: Text('로그아웃',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LogIn()),
                      );
                    },
                  ),
                  Divider(color: Color.fromARGB(255, 126, 113, 159)),
                ],
              ),
            ),
          ],
        ),
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
}
