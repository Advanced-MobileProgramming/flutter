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
  String _profileImagePath = 'image/DefaultProfile.png'; // 기본 프로필 사진

  @override
  void initState() {
    super.initState();
    _username = widget.username; // 초기값 설정
  }

  void _showProfileImageChangeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('프로필 사진 변경'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // DefaultProfile.png 부터 Profile5.png까지 이미지 선택
                for (int i = 0; i <= 5; i++) // 0부터 5까지 반복
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // 이미지 선택시 해당 경로로 변경
                        _profileImagePath = i == 0
                            ? 'image/DefaultProfile.png' // DefaultProfile.png 선택
                            : 'image/Profile$i.png'; // Profile1.png부터 Profile5.png까지 선택
                      });
                      Navigator.of(context).pop(); // 다이얼로그 닫기
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Image.asset(
                        i == 0
                            ? 'image/DefaultProfile.png' // DefaultProfile.png 이미지 표시
                            : 'image/Profile$i.png', // Profile1.png부터 Profile5.png까지 이미지 표시
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
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

  void _showPasswordConfirmationDialog() {
    TextEditingController _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('회원탈퇴'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('회원탈퇴를 위해 비밀번호를 입력해주세요.'),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
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
                String inputPassword = _passwordController.text;
                // 예: 실제 비밀번호를 여기서 가져옴 (현재는 "1234"로 가정)
                String storedPassword = "1234";

                if (inputPassword == storedPassword) {
                  // 탈퇴 성공 처리
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('회원탈퇴가 완료되었습니다.')),
                  );

                  // 로그인 페이지로 이동
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LogIn()),
                  );
                } else {
                  // 비밀번호 불일치 처리
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
                  );
                }
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
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
                        backgroundImage:
                            AssetImage(_profileImagePath), // 변경된 이미지 경로 사용
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
                            '${_username}', // 여기에 실제 유저 닉네임을 넣으세요
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color:
                                  Color.fromARGB(235, 126, 113, 159), // 닉네임 색상
                            ),
                          ),
                          // 유저 ID
                          Text(
                            '@${_username}', // 여기에 실제 유저 id를 넣으세요
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
                      _showProfileImageChangeDialog(); // 프로필 사진 변경 다이얼로그 호출
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
                      _showPasswordConfirmationDialog();
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
