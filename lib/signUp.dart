import 'package:flutter/material.dart';
import 'package:soobook/logIn.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isUsernameAvailable = false; // 아이디 중복 확인 상태
  String _usernameMessage = ''; // 아이디 중복 확인 메시지

  // 회원가입 처리 로직
  void _signUp() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 완료: ${_usernameController.text}')),
      );
    }
  }

  // 아이디 중복 확인 로직
  Future<void> _checkUsernameAvailability() async {
    final username = _usernameController.text;
    if (username.isEmpty) {
      setState(() {
        _usernameMessage = '아이디를 입력해주세요.';
        _isUsernameAvailable = false;
      });
      return;
    }
    // 서버와 통신하여 아이디 중복 확인 (여기서는 비동기 예시로 대체)
    await Future.delayed(Duration(seconds: 1)); // 비동기 요청 시뮬레이션
    setState(() {
      // 예시: 'testuser'는 이미 사용 중인 아이디
      if (username == 'testuser') {
        _isUsernameAvailable = false;
        _usernameMessage = '이미 사용 중인 아이디입니다.';
      } else {
        _isUsernameAvailable = true;
        _usernameMessage = '사용 가능한 아이디입니다.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 50.0, bottom: 50.0)),
              Center(
                child: Image(
                  image: AssetImage('image/logo.png'), // 로고 이미지 경로 설정
                  width: 170.0,
                  height: 190.0,
                ),
              ),
              SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 닉네임 입력
                    TextFormField(
                      controller: _nicknameController,
                      decoration: InputDecoration(
                        labelText: '닉네임',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '닉네임을 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // 아이디 입력
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: '아이디',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.account_circle),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '아이디를 입력해주세요.';
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.check),
                          onPressed: _checkUsernameAvailability,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      _usernameMessage,
                      style: TextStyle(
                        color: _isUsernameAvailable ? Colors.green : Colors.red,
                      ),
                    ),
                    SizedBox(height: 16),

                    // 비밀번호 입력
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 입력해주세요.';
                        } else if (value.length < 6) {
                          return '비밀번호는 6자 이상이어야 합니다.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // 비밀번호 확인 입력
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: '비밀번호 확인',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 다시 입력해주세요.';
                        } else if (value != _passwordController.text) {
                          return '비밀번호가 일치하지 않습니다.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32),

                    // 회원가입 버튼
                    ElevatedButton(
                      onPressed: _signUp,
                      child: Text('회원가입'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 110, 66, 172),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 150),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 20),

                    // 로그인 페이지로 이동
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => LogIn()),
                        );
                      },
                      child: Text(
                        '로그인',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
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
    _nicknameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
