// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names, prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend_matching/components/develop_keyword.dart';
import 'package:frontend_matching/components/gap.dart';
import 'package:frontend_matching/components/hobby_keyword.dart';
import 'package:frontend_matching/components/idol_keyword.dart';
import 'package:frontend_matching/components/major_keyword.dart';
import 'package:frontend_matching/components/mind_keyword.dart';
import 'package:frontend_matching/components/trainning_keyword.dart';
import 'package:frontend_matching/controllers/info_modify_controller.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/text_style.dart';
import 'package:get/get.dart';

class MyKeywordModifyPage extends StatefulWidget {
  const MyKeywordModifyPage({Key? key});

  @override
  _MyKeywordModifyPageState createState() => _MyKeywordModifyPageState();
}

class _MyKeywordModifyPageState extends State<MyKeywordModifyPage> {
  List<String> selectedHobbyKeywords = [];
  List<String> selectedMindKeywords = [];
  List<String> selectedTrainningKeywords = [];
  List<String> selectedIdolKeywords = [];
  List<String> selectedDevelopKeywords = [];
  List<String> selectedMajorKeywords = [];
  bool isElevationButtonEnabled = false; // ElevationButton 활성/비활성 상태
  String accessToken = '';
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
  void initState() {
    super.initState();
    final controller = Get.find<UserDataController>();
    if (controller.user.value != null) {
      accessToken = controller.accessToken;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '내 키워드 설정하기',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        titleTextStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        backgroundColor: Colors.white,
      ),
      backgroundColor: blueColor5,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(),
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
                    ? () async {
                        String HobbyKeywords = selectedHobbyKeywords.join(',');
                        String MindKeywords = selectedMindKeywords.join(',');
                        String TrainningKeywords =
                            selectedTrainningKeywords.join(',');
                        String IdolKeywords = selectedIdolKeywords.join(',');
                        String MajorKeywords = selectedMajorKeywords.join(',');
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

                        await InfoModifyController()
                            .KeywordModify(combinedKeywords);

                        Get.back();
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
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
