//프로필 수정 페이지
import 'package:flutter/material.dart';
import 'package:soobook/allBooks.dart';
import 'package:soobook/bookShelf.dart';
import 'package:soobook/myHome.dart'; // HomePage가 필요하다면 임포트
import 'package:soobook/login.dart'; // 로그인 페이지 임포트
import 'package:soobook/myPage.dart';

class ProfileEditPage extends StatefulWidget {
  final String username;
  ProfileEditPage({required this.username});
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  int _selectedIndex = 3;

  TextEditingController _nicknameController = TextEditingController();

  // _username을 상태로 관리
  String _username = "";

  @override
  void initState() {
    super.initState();
    _username = widget.username; // 초기값 설정
  }

  // 닉네임 변경을 위한 다이얼로그 표시 함수
  void _showNicknameChangeDialog() {
    _nicknameController.text = widget.username; // 기본값으로 현재 유저 닉네임 설정

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('닉네임 변경'),
          content: TextField(
            controller: _nicknameController,
            decoration: InputDecoration(
              hintText: '새로운 닉네임을 입력하세요',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                // 여기서 새로운 닉네임을 처리
                setState(() {
                  _username = _nicknameController.text; // _username을 업데이트
                });
                Navigator.of(context).pop(); // 다이얼로그 닫기
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('닉네임이 변경되었습니다.')),
                );
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(username: widget.username)), // 수정 필요
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BookshelfPage(username: widget.username)),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AllBooksPage(username: widget.username)),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyPage(
                  username: widget.username,
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
        automaticallyImplyLeading: true,
        toolbarHeight: 120.0,
        titleSpacing: 20.0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // 프로필 사진이 포함된 FloatingActionButton
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 20.0, left: 20.0, right: 20.0),
              child: SizedBox(
                width: 400, // 원하는 너비
                height: 180, // 원하는 높이
                child: FloatingActionButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('프로필 수정 페이지로 이동')),
                    );
                  },
                  child: Row(
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
                            '${widget.username}', // 여기에 실제 유저 닉네임을 넣으세요
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color:
                                  Color.fromARGB(235, 126, 113, 159), // 닉네임 색상
                            ),
                          ),
                          // 유저 ID
                          Text(
                            '@${widget.username}', // 여기에 실제 유저 id를 넣으세요
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  Color.fromARGB(235, 126, 113, 159), // ID 색상
                            ),
                          ),
                        ],
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
                    leading: Icon(Icons.auto_fix_high, color: Colors.black),
                    title: Text('프로필 꾸미기',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('독후감 페이지로 이동')),
                      );
                    },
                  ),
                  Divider(color: Color.fromARGB(255, 126, 113, 159)),
                  ListTile(
                    leading: Icon(Icons.edit, color: Colors.black),
                    title: Text('닉네임 변경',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {
                      _showNicknameChangeDialog();
                    },
                  ),
                  Divider(color: Color.fromARGB(255, 126, 113, 159)),
                  ListTile(
                    leading: Icon(Icons.exit_to_app, color: Colors.black),
                    title: Text('회원탈퇴',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('의견 보내기 페이지로 이동')),
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
