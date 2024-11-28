import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:soobook/signUp.dart';
import 'package:soobook/myHome.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // 기존 코드
  // String? _username;
  // String? _password;

  // void _login() {
  //   if (_formKey.currentState!.validate()) {
  //     // 로그인 처리 로직
  //     setState(() {
  //       _username = _usernameController.text;
  //       _password = _passwordController.text;
  //     });

  //     print("Logging in with username: $_username");

  //     if (_username != null && _username!.isNotEmpty) {
  //       // 로그인 성공 메시지
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Logged in as $_username')),
  //       );

  //       // HomePage로 이동하며 아이디 전달
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => HomePage(username: _username!),
  //         ),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('로그인 아이디를 입력해주세요.')),
  //       );
  //     }
  //   }
  // }

  void _firebaseLogin() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      // Firebase DB에서 사용자 정보 조회
      final DatabaseReference userRef = FirebaseDatabase.instance.ref("users");

      try {
        final snapshot = await userRef.child(username).get();
        if (!snapshot.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('사용자가 존재하지 않습니다.')),
          );
          return;
        }

        // 사용자 닉네임 가져오기
        final nickname = snapshot.child("nickname").value as String?;
        if (nickname == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('닉네임을 가져올 수 없습니다.')),
          );
          return;
        }

        //final storedPassword = snapshot.child("password").value as String;
        final storedPassword = snapshot.child("password").value;

        // 디버깅 로그 추가
        print("Stored Password: $storedPassword");
        print("Entered Password: $password");

        // 수정된 비밀번호 비교 코드
        if (storedPassword != null &&
            storedPassword.toString().trim() == password) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그인 성공')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(nickname: nickname),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
          );
        }
      } catch (e) {
        print("Firebase Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 중 오류가 발생했습니다.')),
        );
      }

      // 기존 비밀번호 비교 코드
      //   if(storedPassword == password) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text('로그인 성공')),
      //     );
      //     Navigator.pushReplacement(context,
      //       MaterialPageRoute(
      //         builder: (context) => HomePage(username: username)
      //       ),
      //     );
      //   } else {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
      //     );
      //   }
      // } catch (e) {
      //   print(e);
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('로그인 중 오류가 발생했습니다.')),
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Log in'),
      //   backgroundColor: Colors.redAccent,
      //   centerTitle: true,
      //   leading: IconButton(
      //     icon: Icon(Icons.menu),
      //     onPressed: () {},
      //   ),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(Icons.search),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 50.0, bottom: 100.0)),
              Center(
                child: Image(
                  image: AssetImage('image/logo.png'),
                  width: 170.0,
                  height: 190.0,
                ),
              ),
              SizedBox(height: 40),
              // 로그인 폼
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 아이디 입력
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: '아이디',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '아이디를 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    // 비밀번호 입력
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true, // 비밀번호는 숨겨서 입력
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32),
                    // 로그인 버튼
                    ElevatedButton(
                      //onPressed: _login,
                      onPressed: _firebaseLogin,
                      child: Text('로그인'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 110, 66, 172),
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 150),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 20),
                    // ElevatedButton(
                    //   onPressed: _login,
                    //   child: Text('회원가입'),
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.white,
                    //     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 150),
                    //     textStyle: TextStyle(fontSize: 16,),
                    //     side: BorderSide.none,
                    //   ),
                    // ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()),
                          );
                        },
                        child: Text(
                          '회원가입',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
