import 'package:flutter/material.dart';
import 'login.dart';
import 'myHome.dart';
import 'allBooks.dart';
import 'bookShelf.dart';
import 'myPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      title: 'SooBook',
      home: SplashScreen(), // SplashScreen을 첫 화면으로 설정
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 2초 후에 로그인 화면으로 이동
    Future.delayed(Duration(seconds: 2), () {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => LogIn()),
      // );

      /* myHome.dart 테스트용 - testUser로 ID 넘겨서 바로 화면 홈화면 띄움 */
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(username: "testUser"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'image/logo.png', // 로고 이미지
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
