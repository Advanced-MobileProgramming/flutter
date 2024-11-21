import 'package:flutter/material.dart';
import 'package:soobook/allBooks.dart';
import 'package:soobook/bookShelf.dart';
import 'package:soobook/myHome.dart'; // HomePage가 필요하다면 임포트

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int _selectedIndex = 3;

  // 탭을 눌렀을 때 페이지 변경
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // 홈 탭 클릭 시 MyHomePage로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  username: 'username',
                )), // 실제 HomePage 위젯을 임포트한 후 수정
      );
    } else if (index == 1) {
      // 책장 탭 클릭 시 BookshelfPage로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BookshelfPage()),
      );
    } else if (index == 2) {
      // 도서 탭 클릭 시 AllBooksPage로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AllBooksPage()),
      );
    } else if (index == 3) {
      // 마이페이지 탭 클릭 시 MyPage로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이 페이지',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 126, 113, 159))),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // 뒤로 가기 버튼 비활성화
        toolbarHeight: 120.0, // AppBar 높이를 조정하여 더 많은 패딩 추가
        titleSpacing: 20.0, // 타이틀과 왼쪽 모서리 사이의 간격을 늘림
      ),
      body: Container(
        color: Colors.white, // 배경색 흰색으로 설정
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '마이페이지입니다.', // 마이페이지 메시지
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // 로그아웃 기능 추가 (예시)
                  // 예를 들어, 로그인 페이지로 이동하거나 세션 종료 처리
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('로그아웃 처리')),
                  );
                },
                child: Text('로그아웃'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // 앱 설정 페이지로 이동할 수 있는 예시
                  // 예: SettingsPage로 이동
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('설정 페이지로 이동')),
                  );
                },
                child: Text('앱 설정'),
              ),
            ],
          ),
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
