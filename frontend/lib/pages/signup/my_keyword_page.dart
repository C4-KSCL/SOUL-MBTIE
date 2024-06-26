// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:frontend_matching/components/develop_keyword.dart';
import 'package:frontend_matching/components/gap.dart';
import 'package:frontend_matching/components/hobby_keyword.dart';
import 'package:frontend_matching/components/idol_keyword.dart';
import 'package:frontend_matching/components/major_keyword.dart';
import 'package:frontend_matching/components/mind_keyword.dart';
import 'package:frontend_matching/components/trainning_keyword.dart';
import 'package:frontend_matching/controllers/signup_controller.dart';
import 'package:frontend_matching/pages/signup/friend%20mbti_page.dart';
import 'package:frontend_matching/pages/signup/my_mbti_page.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/text_style.dart';
import 'package:get/get.dart';

class MyKeywordPage extends StatefulWidget {
  const MyKeywordPage({Key? key});

  @override
  _MyKeywordPageState createState() => _MyKeywordPageState();
}

class _MyKeywordPageState extends State<MyKeywordPage> {
  SignupController signupController = Get.find<SignupController>();
  List<String> selectedHobbyKeywords = [];
  List<String> selectedMindKeywords = [];
  List<String> selectedTrainningKeywords = [];
  List<String> selectedIdolKeywords = [];
  List<String> selectedDevelopKeywords = [];
  List<String> selectedMajorKeywords = [];
  bool isElevationButtonEnabled = false; // ElevationButton 활성/비활성 상태

  // ElevationButton 활성/비활성 여부를 체크하는 함수
  void checkElevationButtonStatus() {
    setState(() {
      isElevationButtonEnabled = selectedHobbyKeywords.isNotEmpty &&
          selectedMindKeywords.isNotEmpty &&
          selectedTrainningKeywords.isNotEmpty &&
          selectedIdolKeywords.isNotEmpty &&
          selectedDevelopKeywords.isNotEmpty &&
          selectedMajorKeywords.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'keyword',
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
                builder: (context) => const MyMbtiPage(),
              ),
            );
          },
        ),
      ),
      backgroundColor: blueColor5,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                '나는',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Color(0xFF7EA5F3),
                ),
              ),
              Text(
                '어떤 사람일까요?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              Gap(),
              SizedBox(
                height: 30,
                child: Text('여가 키워드', style: greyTextStyle1),
              ),
              HobbyKeyWord(
                onKeywordsSelected: (keywords) {
                  selectedHobbyKeywords = keywords;
                  checkElevationButtonStatus();
                },
              ),
              SizedBox(
                height: 30,
                child: Text('성격 키워드', style: greyTextStyle1),
              ),
              MindKeyWord(
                onKeywordsSelected: (keywords) {
                  selectedMindKeywords = keywords;
                  checkElevationButtonStatus();
                },
              ),
              SizedBox(
                height: 30,
                child: Text('운동 키워드', style: greyTextStyle1),
              ),
              TrainningKeyWord(
                onKeywordsSelected: (keywords) {
                  selectedTrainningKeywords = keywords;
                  checkElevationButtonStatus();
                },
              ),
              SizedBox(
                height: 30,
                child: Text('아이돌 키워드', style: greyTextStyle1),
              ),
              IdolKeyWord(
                onKeywordsSelected: (keywords) {
                  selectedIdolKeywords = keywords;
                  checkElevationButtonStatus();
                },
              ),
              SizedBox(
                height: 30,
                child: Text('자기계발 키워드', style: greyTextStyle1),
              ),
              DevelopKeyWord(
                onKeywordsSelected: (keywords) {
                  selectedDevelopKeywords = keywords;
                  checkElevationButtonStatus();
                },
              ),
              SizedBox(
                height: 30,
                child: Text('대학 키워드', style: greyTextStyle1),
              ),
              MajorKeyWord(
                onKeywordsSelected: (keywords) {
                  selectedMajorKeywords = keywords;
                  checkElevationButtonStatus();
                },
              ),
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
                          String HobbyKeywords =
                              selectedHobbyKeywords.join(',');
                          String MindKeywords = selectedMindKeywords.join(',');
                          String TrainningKeywords =
                              selectedTrainningKeywords.join(',');
                          String IdolKeywords = selectedIdolKeywords.join(',');
                          String MajorKeywords =
                              selectedMajorKeywords.join(',');
                          String DevelopKeywords =
                              selectedDevelopKeywords.join(',');
                          String combinedKeywords = HobbyKeywords +
                              ',' +
                              MindKeywords +
                              ',' +
                              TrainningKeywords +
                              "," +
                              IdolKeywords +
                              ',' +
                              MajorKeywords +
                              "," +
                              DevelopKeywords;

                          print(combinedKeywords);
                          signupController.addToSignupArray(combinedKeywords);
                          print(signupController.signupArray);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FriendMbtiPage(),
                            ),
                          );
                        }
                      : null, // 버튼이 비활성 상태일 때는 null로 설정
                  child: const Text(
                    '다음으로',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}
