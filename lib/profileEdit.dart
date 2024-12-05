import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:soobook/allBooks.dart';
import 'package:soobook/bookShelf.dart';
import 'package:soobook/myHome.dart'; // HomePage가 필요하다면 임포트
import 'package:soobook/login.dart'; // 로그인 페이지 임포트
import 'package:soobook/myPage.dart';

class ProfileEditPage extends StatefulWidget {
  final String userId;
  final String nickname;
  ProfileEditPage({required this.userId, required this.nickname});
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  int _selectedIndex = 3;

  TextEditingController _nicknameController = TextEditingController();

  // _username을 상태로 관리
  String _nickname = "";
  String _profileImagePath = 'image/DefaultProfile.png'; // 기본 프로필 사진
  String _userId = "";

  @override
  void initState() {
    super.initState();
    _nickname = widget.nickname; // 초기값 설정
    _userId = widget.userId;
  }

  void _showProfileImageChangeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('프로필 사진 변경'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 10.0, // 이미지 간의 가로 간격
              runSpacing: 10.0, // 줄 간의 세로 간격
              children: [
                for (int i = 0; i <= 5; i++) // 0부터 5까지 반복
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _profileImagePath = i == 0
                            ? 'image/DefaultProfile.png' // DefaultProfile.png 선택
                            : 'image/Profile$i.png'; // Profile1.png부터 Profile5.png까지 선택
                      });
                      Navigator.of(context).pop(); // 다이얼로그 닫기
                    },
                    child: Image.asset(
                      i == 0
                          ? 'image/DefaultProfile.png' // DefaultProfile.png 이미지 표시
                          : 'image/Profile$i.png', // Profile1.png부터 Profile5.png까지 이미지 표시
                      width: 100,
                      height: 100,
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


void updateNicknameInDatabase(String newNickname) {
  DatabaseReference userRef = FirebaseDatabase.instance.ref('users/${widget.userId}');

  userRef.update({'nickname': newNickname}).then((_) {
    print("닉네임이 성공적으로 업데이트 되었습니다.");
    // UI 업데이트를 위해 상태 변경
    setState(() {
      _nickname = newNickname; // 닉네임 상태 업데이트
    });
    // 변경된 닉네임을 모든 관련 페이지에 반영하기 위해 라우트 업데이트
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => MyPage(userId: widget.userId, nickname: _nickname)),
      ModalRoute.withName('/'),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('닉네임이 변경되었습니다.')),
    );
  }).catchError((error) {
    print("닉네임 업데이트 중 에러 발생: $error");
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text("닉네임 업데이트 중 에러가 발생했습니다: $error")),
    // );
  });
}


  // 닉네임 변경을 위한 다이얼로그 표시 함수
  void _showNicknameChangeDialog() {
    TextEditingController _nicknameController = TextEditingController(); //
    _nicknameController.text = widget.nickname; // 기본값으로 현재 유저 닉네임 설정

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
              String newNickname = _nicknameController.text.trim();
              if (newNickname.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('닉네임을 입력해주세요.')),
                );
                return;
              }
              setState(() {
                _nickname = newNickname; // 닉네임 상태 업데이트
              });
              updateNicknameInDatabase(newNickname); // DB에 닉네임 업데이트
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
            builder: (context) => HomePage(
                userId: widget.userId, nickname: widget.nickname)), // 수정 필요
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BookshelfPage(
                userId: widget.userId, nickname: widget.nickname)),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AllBooksPage(userId: widget.userId, nickname: widget.nickname)),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MyPage(userId: widget.userId, nickname: widget.nickname)),
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
              
              onPressed: () async {
              String inputPassword = _passwordController.text.trim();

              // Firebase에서 비밀번호 확인
              DatabaseReference userRef = FirebaseDatabase.instance.ref('users/${widget.userId}');
              final userSnapshot = await userRef.once();

              if (userSnapshot.snapshot.value != null) {
                Map<String, dynamic> userData = Map<String, dynamic>.from(userSnapshot.snapshot.value as Map);
                String storedPassword = userData['password'];

                if (inputPassword == storedPassword) {
                  // 비밀번호 일치 -> 회원 탈퇴
                  //await userRef.remove(); // Firebase에서 사용자 삭제
                  await _deleteUserAndRelatedData(widget.userId); // 사용자 및 관련 데이터 삭제
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
              } else {
                // 사용자 데이터가 없는 경우
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('사용자 정보를 찾을 수 없습니다.')),
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

  // 사용자 및 관련 데이터 삭제
Future<void> _deleteUserAndRelatedData(String userId) async {
  try {
    // users 테이블에서 삭제
    DatabaseReference userRef = FirebaseDatabase.instance.ref('users/$userId');
    await userRef.remove();

    // bookReports 테이블에서 삭제
    DatabaseReference bookReportsRef = FirebaseDatabase.instance.ref('bookReports/$userId');
    await bookReportsRef.remove();

    // bookshelves 테이블에서 삭제 (예시로 추가한 테이블)
    DatabaseReference bookcasesRef = FirebaseDatabase.instance.ref('bookcases/$userId');
    await bookcasesRef.remove();

    // bookshelves 테이블에서 삭제 (예시로 추가한 테이블)
    DatabaseReference bookcollectionRef = FirebaseDatabase.instance.ref('collections/$userId');
    await bookcollectionRef.remove();

    print("모든 관련 데이터가 삭제되었습니다.");
  } catch (e) {
    print("데이터 삭제 중 에러 발생: $e");
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text("데이터 삭제 중 오류가 발생했습니다: $e")),
    // );
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
                            '${_nickname}', // 여기에 실제 유저 닉네임을 넣으세요
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color:
                                  Color.fromARGB(235, 126, 113, 159), // 닉네임 색상
                            ),
                          ),
                          // 유저 ID
                          Text(
                            '@${_userId}', // 여기에 실제 유저 id를 넣으세요
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
