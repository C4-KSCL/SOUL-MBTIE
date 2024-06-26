import 'package:flutter/material.dart';
import 'package:frontend_matching/components/textfield.dart';
import 'package:frontend_matching/components/textform_field.dart';
import 'package:frontend_matching/pages/login/login_page.dart';
import 'package:frontend_matching/pages/login/modify_password_page.dart';
import 'package:frontend_matching/services/find_password.dart';
import 'package:frontend_matching/theme/colors.dart';

class FindPasswordPage extends StatefulWidget {
  const FindPasswordPage({Key? key}) : super(key: key);

  @override
  _FindPasswordPageState createState() => _FindPasswordPageState();
}

class _FindPasswordPageState extends State<FindPasswordPage> {
  final TextEditingController schoolEmailController = TextEditingController();
  final TextEditingController authController = TextEditingController();
  String email = '';
  String verificationCode = ''; // 인증 코드를 저장할 변수 추가

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('비밀번호 찾기'),
        elevation: 1.0,
        titleTextStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        backgroundColor: blueColor3,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
        ),
      ),
      backgroundColor: blueColor5,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
              child: ButtonTextFieldBox(
                hintText: '입력해주세요',
                onPressed: () async {
                  email = schoolEmailController.text;
                  String? code = await FindPassword.findPassword(email);
                  if (code != null) {
                    setState(() {
                      verificationCode = code; // 인증 코드 저장
                    });
                  }
                },
                buttonText: '인증하기',
                textEditingController: schoolEmailController,
                textType: '학교 이메일',
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
              child: GetTextContainer(
                typeController: authController,
                textLogo: 'textLogo',
                textType: '인증번호',
              ),
            ),
            SizedBox(height: 260),
            Column(
              children: [
                SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7EA5F3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      if (authController.text == verificationCode) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModifyPasswordPage(),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('인증 실패'),
                              content: Text('인증번호가 올바르지 않습니다.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      '다음으로',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
