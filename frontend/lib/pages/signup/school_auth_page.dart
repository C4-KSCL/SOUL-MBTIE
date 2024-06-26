// ignore_for_file: unused_import, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_matching/components/textfield.dart';
import 'package:frontend_matching/components/textform_field.dart';
import 'package:frontend_matching/config.dart';
import 'package:frontend_matching/controllers/signup_controller.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/pages/login/login_page.dart';
import 'package:frontend_matching/pages/signup/my_info_page.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/text_style.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Future<String?> registerUser(String email) async {
  final Uri url = Uri.parse('${AppConfig.baseUrl}/signup/emailauth');

  try {
    final response = await http.post(
      url,
      body: {
        'email': email,
      },
    );

    if (response.statusCode == 200) {
      print('인증요청 성공!');
      // 서버 응답에서 verificationCode 추출
      Map<String, dynamic> data = json.decode(response.body);
      int verificationCode = data['verificationCode'];

      return verificationCode.toString(); // 숫자를 문자열 변환
    } else {
      print('서버 에러: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('에러 발생: $e');
    return null;
  }
}

class SchoolAuthPage extends StatefulWidget {
  const SchoolAuthPage({Key? key}) : super(key: key);

  @override
  _SchoolAuthPageState createState() => _SchoolAuthPageState();
}

class _SchoolAuthPageState extends State<SchoolAuthPage> {
  final TextEditingController schoolEmailController = TextEditingController();
  final TextEditingController authController = TextEditingController();
  late SignupController signupController;
  String verify = '';
  bool isElevationButtonEnabled = false;

  void checkElevationButtonStatus() {
    setState(() {
      isElevationButtonEnabled = authController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    signupController = Get.put(SignupController());

    authController.addListener(checkElevationButtonStatus);
  }

  @override
  void dispose() {
    authController.removeListener(checkElevationButtonStatus);
    authController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('회원가입하기'),
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
            child: Column(children: [
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
            child: ButtonTextFieldBox(
              hintText: '입력해주세요',
              onPressed: () async {
                String email = schoolEmailController.text;
                String? verificationCode = await registerUser(email);

                if (verificationCode != null) {
                  print('Received verification code: $verificationCode');
                  verify = verificationCode;
                } else {
                  print('Failed to get verification code');
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
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: isElevationButtonEnabled
                      ? () {
                          if (authController.text == verify) {
                            String schoolEmail = schoolEmailController.text;
                            signupController.addToSignupArray(schoolEmail);
                            print(signupController.signupArray);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfoAuthPage(),
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
                        }
                      : null,
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
        ])));
  }
}
