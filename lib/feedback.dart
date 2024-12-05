import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FeedbackPage extends StatefulWidget {
  final String userId;
  final String nickname;

  FeedbackPage({required this.userId, required this.nickname});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  // Firebase에서 피드백을 전송하는 메소드
  Future<void> _submitFeedback() async {
    if (_feedbackController.text.isEmpty) {
      // 피드백이 비어 있으면 알림 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('피드백을 입력해주세요.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Firebase Realtime Database에 피드백 저장
      final feedbackRef = FirebaseDatabase.instance.ref("feedbacks");
      await feedbackRef.push().set({
        "userId": widget.userId,
        "nickname": widget.nickname,
        "feedback": _feedbackController.text,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      });

      // 성공적으로 전송되었을 때
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('피드백이 전송되었습니다!')),
      );
      // 텍스트 필드 초기화
      _feedbackController.clear();
    } catch (e) {
      // 오류 발생 시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('피드백 전송에 실패했습니다. 다시 시도해주세요.')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '의견 보내기',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' 개발자에게 보내는 의견을 입력해주세요!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 126, 113, 159),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: '피드백을 입력하세요...',
                filled: true,
                fillColor: Color.fromARGB(98, 187, 163, 187),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _isSubmitting
                ? Center(child: CircularProgressIndicator())
                : Align(
                    alignment: Alignment.centerRight, // 버튼을 오른쪽으로 정렬
                    child: ElevatedButton(
                      onPressed: _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 126, 113, 159),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      ),
                      child: Text(
                        '제출',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // 텍스트 색상 변경
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
