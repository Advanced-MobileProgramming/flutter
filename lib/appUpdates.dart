import 'package:flutter/material.dart';

class AppUpdatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '소프트웨어 업데이트',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 126, 113, 159),
          ),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 120.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'VERSION 1.1.0',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 126, 113, 159),
                ),
              ),
              SizedBox(height: 20),
              Text(
                '이번 업데이트에서 추가된 기능 및 개선 사항은 다음과 같습니다.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '1. 새로운 UI 디자인',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '사용자 인터페이스(UI)가 새롭게 디자인되었습니다. 더 직관적이고 깔끔한 화면으로 개선되어 사용자가 더 쉽게 앱을 이용할 수 있습니다.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '2. 버그 수정',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '앱에서 발생한 몇 가지 버그가 수정되었습니다. 그 중 하나는 앱 실행 시 갑작스런 종료 문제였습니다. 이 문제는 이제 해결되었습니다.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '3. 성능 개선',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '앱의 성능이 향상되었습니다. 이제 더 빠르게 반응하며, 데이터 로딩 속도가 개선되었습니다.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '4. 새로운 기능 추가: 리뷰・독후감 관리 페이지',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '이제 내가 작성했던 리뷰와 독후감을 관리할 수 있는 기능이 추가되었습니다. 마이페이지에서 내가 쓴 리뷰와 독후감을 한번에 볼 수 있고 수정 및 삭제할 수 있습니다.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '5. 사용자 피드백 기능 추가',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '사용자가 앱 내에서 직접 피드백을 남길 수 있는 기능이 추가되었습니다. 이제 앱의 기능 개선이나 버그 신고를 쉽게 할 수 있습니다.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '6. 기타 개선 사항',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '앱의 여러 부분에서 작은 버그 수정 및 성능 개선이 이루어졌습니다. 사용자의 경험을 보다 향상시키기 위해 지속적으로 개선 작업을 진행하고 있습니다.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 126, 113, 159), // 배경색 설정
                  foregroundColor: Colors.white, // 텍스트 색상 설정
                ),
                child: Text('업데이트 완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
