import 'package:flutter/material.dart';

class AppTOSPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '이용약관',
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SOOBOOK 통합 서비스 이용약관',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '본 약관은 SOOBOOK 서비스에 대한 이용자와 회사 간의 법적 관계를 정의합니다.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '1. 서비스 이용\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // 번호 부분 굵게
                ),
              ),
              Text(
                '본 서비스는 사용자에게 책 정보 검색, 책장 관리, 북마크 저장 등 다양한 기능을 제공합니다. 서비스 이용자는 본 서비스를 사용하는 동안 약관을 준수해야 하며, 약관에 동의하지 않는 경우 서비스 이용을 중지해야 합니다.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '2. 개인정보 보호\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // 번호 부분 굵게
                ),
              ),
              Text(
                '회사는 사용자의 개인정보를 보호하기 위해 최선을 다합니다. 사용자가 제공한 개인정보는 서비스 제공 목적에만 사용되며, 제3자에게 제공되지 않습니다.\n'
                '회사는 개인정보 보호를 위한 보안 시스템을 운영하고 있으며, 사용자는 본인의 개인정보를 안전하게 관리할 책임이 있습니다.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '3. 서비스의 변경 및 종료\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // 번호 부분 굵게
                ),
              ),
              Text(
                '회사는 사용자의 편의성을 높이기 위해 서비스를 수시로 변경할 수 있습니다. 서비스 변경 사항은 앱 내 공지사항을 통해 사용자에게 전달됩니다.\n'
                '또한, 회사는 예고 없이 서비스를 종료할 수 있으며, 이 경우 사용자에게 사전 통지를 제공할 수 있습니다.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '4. 사용자 의무\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // 번호 부분 굵게
                ),
              ),
              Text(
                '사용자는 본 서비스를 이용할 때, 타인의 권리를 침해하거나 불법적인 활동을 하지 않도록 해야 합니다. 또한, 서비스 이용 중 불법적인 콘텐츠를 공유하거나 유포하는 행위는 금지됩니다.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '5. 책임의 한계\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // 번호 부분 굵게
                ),
              ),
              Text(
                '회사는 본 서비스에서 제공되는 콘텐츠의 정확성 및 완전성에 대해 보증하지 않습니다. 서비스 이용 중 발생한 문제에 대해 회사는 책임을 지지 않습니다.\n'
                '서비스 이용에 따른 불편함이나 손해에 대해서는 회사가 책임을 지지 않으며, 사용자는 본 약관에 동의한 것으로 간주됩니다.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '6. 약관의 변경\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // 번호 부분 굵게
                ),
              ),
              Text(
                '회사는 필요에 따라 본 약관을 수정할 수 있습니다. 약관의 변경 내용은 앱 내 공지사항을 통해 사전 고지됩니다. 변경된 약관은 공지된 날로부터 효력이 발생합니다.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '7. 서비스 이용의 종료\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // 번호 부분 굵게
                ),
              ),
              Text(
                '사용자는 언제든지 서비스 이용을 중단할 수 있으며, 이 경우 서비스 제공자는 사용자의 데이터 보존 및 계정 삭제 절차를 따릅니다.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '8. 기타\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // 번호 부분 굵게
                ),
              ),
              Text(
                '본 약관에서 명시되지 않은 사항에 대해서는 관련 법률에 따르며, 사용자와 회사 간의 분쟁은 관할 법원에서 해결합니다.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
