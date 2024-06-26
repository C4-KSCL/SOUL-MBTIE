// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, use_build_context_synchronously, annotate_overrides

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend_matching/components/textfield.dart';
import 'package:frontend_matching/components/textform_field.dart';
import 'package:frontend_matching/controllers/info_modify_controller.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/pages/profile/buttons/Info_modify_button.dart';
import 'package:frontend_matching/pages/profile/mykeyword_modify_page.dart';
import 'package:frontend_matching/pages/profile/mymbti_modify_page.dart';
import 'package:frontend_matching/pages/profile/userAvatar.dart';
import 'package:frontend_matching/services/nickname_check.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/text_style.dart';
import 'package:get/get.dart';

class InfoModifyPage extends StatefulWidget {
  const InfoModifyPage({Key? key}) : super(key: key);

  @override
  _InfoModifyPageState createState() => _InfoModifyPageState();
}

class _InfoModifyPageState extends State<InfoModifyPage> {
  late InfoModifyController infoModifyController;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String my_email = '';
  String my_password = '';
  String my_nickname = '';
  String my_phoneNumber = '';
  String my_age = '';
  String accessToken = '';
  String refreshToken = '';
  String my_profileImagePath = '';
  bool isElevationButtonEnabled = false;
  bool isNicknameVerified = true; // 닉네임 수정 전에는 항상 활성화

  @override
  void initState() {
    super.initState();
    infoModifyController = Get.find<InfoModifyController>();
    final controller = Get.find<UserDataController>();

    if (controller.user.value != null) {
      accessToken = controller.accessToken;
      refreshToken = controller.refreshToken;
      my_email = controller.user.value!.email;
      my_password = controller.user.value!.password;
      my_nickname = controller.user.value!.nickname;
      my_phoneNumber = controller.user.value!.phoneNumber;
      my_age = controller.user.value!.age;
      my_profileImagePath = controller.user.value!.userImage ?? '';
      print(my_profileImagePath);

      passwordController.text = my_password;
      nicknameController.text = my_nickname;
      phoneNumberController.text = my_phoneNumber;
      ageController.text = my_age;
    }

    nicknameController.addListener(() {
      setState(() {
        isNicknameVerified =
            nicknameController.text == my_nickname; // 닉네임이 변경되었을 때 인증 상태 초기화
      });
    });
  }

  @override
  void dispose() {
    nicknameController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double medWidth = MediaQuery.of(context).size.width;
    final double medHeight = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('내 정보 수정하기'),
          backgroundColor: blueColor5,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        backgroundColor: blueColor5,
        body: SingleChildScrollView(
            child: Stack(
          children: [
            Positioned(
                top: medHeight / 4.1,
                child: Container(
                    height: medHeight,
                    decoration: const BoxDecoration(
                        color: Color(0xFFFCFCFF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                    padding: EdgeInsets.fromLTRB(0, medHeight, medWidth, 0.0))),
            Opacity(
              opacity: 0.8,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(width: 0.5, color: Colors.grey))),
                height: statusBarHeight + 55,
              ),
            ),
            Container(
              color: blueColor5,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: medHeight / 10,
                    ),
                    UserAvatar(
                      img: my_profileImagePath,
                      medWidth: medWidth,
                      accessToken: accessToken,
                      deletePath: my_profileImagePath,
                      email: my_email,
                      password: my_password,
                      isModifiable: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          my_nickname,
                          style: TextStyle(
                              fontSize: 29, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(medWidth / 45),
                      child: GetTextContainer(
                        textLogo: '',
                        textType: '비밀번호',
                        typeController: passwordController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(medWidth / 45),
                      child: ButtonTextFieldBox(
                        hintText: '입력하세요',
                        onPressed: () async {
                          String nickname = nicknameController.text;
                          if (nickname.length >= 8) {
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
                                        isNicknameVerified = false;
                                      },
                                      child: const Text('확인'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            bool? check = await NickNameCheck.checknickname(
                                nickname, context);
                            setState(() {
                              if (check == true) {
                                isNicknameVerified =
                                    true; // 닉네임 인증 상태를 true로 설정
                              }
                            });
                          }
                        },
                        textEditingController: nicknameController,
                        buttonText: '인증하기',
                        textType: '닉네임',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(medWidth / 45),
                      child: GetTextContainer(
                        textLogo: '',
                        textType: '전화번호',
                        typeController: phoneNumberController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(medWidth / 45),
                      child: GetTextContainer(
                        textLogo: '',
                        textType: '나이',
                        typeController: ageController,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 15),
                        InfoModifyButton(
                            medHeight: medHeight,
                            medWidth: medWidth,
                            pressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyMbtiModifyPage(),
                                ),
                              );
                            },
                            img: 'assets/images/mbti.png',
                            str: '내 MBTI 수정하기'),
                        InfoModifyButton(
                            medHeight: medHeight,
                            medWidth: medWidth,
                            pressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyKeywordModifyPage(),
                                ),
                              );
                            },
                            img: 'assets/images/keyword.jpeg',
                            str: '내 키워드 수정하기'),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.all(medWidth / 45),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Color(0xFF7EA5F3),
                          minimumSize: Size(300, 50),
                        ),
                        onPressed: isNicknameVerified
                            ? () async {
                                String password = passwordController.text;
                                String nickname = nicknameController.text;
                                String phoneNumber = phoneNumberController.text;
                                String age = ageController.text;
                                print(phoneNumber);
                                if (password.isNotEmpty &&
                                    nickname.isNotEmpty &&
                                    phoneNumber.isNotEmpty &&
                                    age.isNotEmpty) {
                                  await infoModifyController.InfoModify(
                                    password,
                                    nickname,
                                    phoneNumber,
                                    age,
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('정보 수정'),
                                        content: Text('정보가 수정되었습니다.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('확인'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('정보 수정'),
                                        content: Text('모든 값을 입력해주세요!'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text('확인'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            : null, // 닉네임 인증 상태에 따라 비활성화
                        child: const Text('수정하기',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ]),
            ),
          ],
        )));
  }
}
