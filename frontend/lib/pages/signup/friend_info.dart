// ignore_for_file: prefer_const_constructors, must_be_immutable, unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend_matching/components/gap.dart';
import 'package:frontend_matching/components/gender_button.dart';
import 'package:frontend_matching/components/textform_field.dart';
import 'package:frontend_matching/controllers/signup_controller.dart';
import 'package:frontend_matching/pages/init_page.dart';
import 'package:frontend_matching/pages/signup/friend_keyword_page.dart';
import 'package:frontend_matching/pages/signup/imageUpload/profile_image_page.dart';
import 'package:frontend_matching/pages/signup/imageUpload/select_image_page.dart';
import 'package:frontend_matching/pages/signup/school_auth_page.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';
// ignore_for_file: unused_import
import 'package:http/http.dart' as http;
import '../login/login_page.dart';

Future<void> registerUser(
  String email,
  String password,
  String nickname,
  String phoneNumber,
  String age,
  String gender,
  String myMBTI,
  String myKeyword,
  String friendMBTI,
  String friendKeyword,
  String friendMaxAge,
  String friendMinAge,
  String friendGender,
) async {
  final Uri url = Uri.parse('https://soulmbti.shop:8000/signup/register');

  try {
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
        'nickname': nickname,
        'phoneNumber': phoneNumber,
        'age': age,
        'gender': gender,
        'myMBTI': myMBTI,
        'myKeyword': myKeyword,
        'friendMBTI': friendMBTI,
        'friendKeyword': friendKeyword,
        'friendMaxAge': friendMaxAge,
        'friendMinAge': friendMinAge,
        'friendGender': friendGender,
      },
    );

    if (response.statusCode == 200) {
      print('회원가입 성공!');
    } else if (response.statusCode == 401) {
      print('중복된 이메일입니다. 비밀번호 찾기를 이용하세요.');
    } else {
      print('서버 에러: ${response.statusCode}');
    }
  } catch (e) {
    print('에러 발생: $e');
  }
}

class FriendInfoPage extends StatelessWidget {
  FriendInfoPage({super.key});
  final TextEditingController minageController = TextEditingController();
  final TextEditingController maxageController = TextEditingController();
  int genderInt = 10;
  String genderString = '';

  SignupController signupController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'info',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.0,
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
                builder: (context) => const FriendKeywordPage(),
              ),
            );
          },
        ),
      ),
      backgroundColor: blueColor5,
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text(
                '친구',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Color.fromARGB(255, 212, 118, 172),
                ),
              ),
              Text(
                '정보는?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              Gap(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
                child: GetTextContainer(
                  typeController: maxageController,
                  textLogo: '',
                  textType: '최대나이',
                  onChanged: (value) => signupController.maxage.value = value,
                ),
              ),
              Gap(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
                child: GetTextContainer(
                  typeController: minageController,
                  textLogo: '',
                  textType: '최소나이',
                  onChanged: (value) => signupController.minage.value = value,
                ),
              ),
              Gap(),
              Gap(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
                child: GenderButton(
                  onGenderSelected: (selectedValue) {
                    genderInt = selectedValue;
                    if (genderInt == 1) {
                      genderString = "남";
                    } else {
                      genderString = "여";
                    }
                    print(genderString);
                    signupController.friendGender(genderString);
                    print(signupController.friendButtonEnabled.value);
                  },
                ),
              ),
              Gap(),
              Gap(),
              SizedBox(
                width: 350,
                height: 50,
                child: Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7EA5F3),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: signupController.friendButtonEnabled.value
                        ? () async {
                            // signupController에(배열) 친구정보 입력값 대입
                            String minage = minageController.text;
                            String maxage = maxageController.text;
                            int minage_int = int.parse(minage);
                            int maxage_int = int.parse(maxage);
                            if (minage_int > maxage_int) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('나이 오류'),
                                    content: Text('최소나이가 최대나이보다 많습니다!'),
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
                            } else {
                              signupController.addToSignupArray(maxage);
                              signupController.addToSignupArray(minage);
                              signupController.addToSignupArray(genderString);

                              print(signupController.signupArray);
                              print(signupController.friendButtonEnabled.value);

                              await registerUser(
                                signupController.signupArray[0],
                                signupController.signupArray[1],
                                signupController.signupArray[2],
                                signupController.signupArray[3],
                                signupController.signupArray[4],
                                signupController.signupArray[5],
                                signupController.signupArray[6],
                                signupController.signupArray[7],
                                signupController.signupArray[8],
                                signupController.signupArray[9],
                                signupController.signupArray[10],
                                signupController.signupArray[11],
                                signupController.signupArray[12],
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileImagePage(),
                                ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
