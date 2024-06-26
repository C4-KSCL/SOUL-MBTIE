// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:frontend_matching/components/gender_button.dart';
import 'package:frontend_matching/components/textfield.dart';
import 'package:frontend_matching/components/textform_field.dart';
import 'package:frontend_matching/controllers/signup_controller.dart';
import 'package:frontend_matching/pages/signup/my_mbti_page.dart';
import 'package:frontend_matching/pages/signup/school_auth_page.dart';
import 'package:frontend_matching/services/nickname_check.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class InfoAuthPage extends StatefulWidget {
  const InfoAuthPage({Key? key}) : super(key: key);

  @override
  _InfoAuthPageState createState() => _InfoAuthPageState();
}

class _InfoAuthPageState extends State<InfoAuthPage> {
  SignupController signupController = Get.find<SignupController>();

  final TextEditingController passwordController =
      TextEditingController(); //비밀번호
  final TextEditingController nicknameController =
      TextEditingController(); //닉네임
  final TextEditingController numberController = TextEditingController(); //전화번호
  final TextEditingController ageController = TextEditingController(); //나이

  // 성별 선택을 위한 변수 추가
  bool isMaleSelected = false;
  bool isFemaleSelected = false;
  int genderInt = 0;
  String genderString = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            signupController.deleteToSignupArray();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SchoolAuthPage(),
              ),
            );
          },
        ),
      ),
      backgroundColor: blueColor5,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
              child: GetTextContainer(
                typeController: passwordController,
                textLogo: 'textLogo',
                textType: '비밀번호',
                onChanged: (value) {
                  signupController.password.value = value;
                  print("패스워드 상태좀보자 : ${signupController.password.value}");
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
              child: ButtonTextFieldBox(
                hintText: '입력해주세요',
                buttonText: '인증하기',
                textEditingController: nicknameController,
                onPressed: () async {
                  // 닉네임 인증
                  String nickname = nicknameController.text;
                  if (nickname.length > 8) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('닉네임 길이 오류'),
                          content: Text('최대 8자로 입력해주세요.'),
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
                  signupController.checkNickname(nickname, context);
                },
                textType: '닉네임',
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
              child: GetTextContainer(
                typeController: numberController,
                textLogo: 'textLogo',
                textType: '전화번호',
                onChanged: (value) =>
                    signupController.phoneNumber.value = value,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
              child: GetTextContainer(
                typeController: ageController,
                textLogo: 'textLogo',
                textType: '나이',
                onChanged: (value) => signupController.age.value = value,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('성별'),
                  GenderButton(
                    onGenderSelected: (selectedValue) {
                      setState(() {
                        genderInt = selectedValue;
                        genderString = (genderInt == 1) ? "남" : "여";
                        // 성별 선택시 상태 업데이트
                        signupController.setGender(genderString);
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 350,
              height: 50,
              child: Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7EA5F3),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: signupController.isElevationButtonEnabled.value
                        ? () {
                            String password = passwordController.text;
                            String nickname = nicknameController.text;
                            String phoneNumber = numberController.text;

                            String age = ageController.text;

                            signupController.addToSignupArray(password);
                            signupController.addToSignupArray(nickname);
                            signupController.addToSignupArray(phoneNumber);
                            signupController.addToSignupArray(age);
                            signupController.addToSignupArray(genderString);

                            print(signupController.signupArray);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyMbtiPage(),
                              ),
                            );
                          }
                        : null,
                    child: const Text('다음으로',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
