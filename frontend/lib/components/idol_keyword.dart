// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/signup_controller.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';

class IdolKeyWord extends StatefulWidget {
  final Function(List<String>) onKeywordsSelected;

  IdolKeyWord({Key? key, required this.onKeywordsSelected}) : super(key: key);

  @override
  _IdolKeyWordState createState() => _IdolKeyWordState();
}

class _IdolKeyWordState extends State<IdolKeyWord> {
  SignupController signupController = Get.find<SignupController>();
  final controller = GroupButtonController(selectedIndex: 20);
  List<String> selectedKeywords = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Center(
          child: Column(
            children: [
              GroupButton(
                controller: controller,
                isRadio: false,
                buttons: [
                  "프로미스나인",
                  "BTS",
                  "세븐틴",
                  "아이브",
                  "트와이스",
                  "블랙핑크",
                  "에스파",
                  "NCT",
                  "레드벨벳",
                  "ITZY",
                ],
                onSelected: (keyword, i, selected) {
                  setState(() {
                    if (selected) {
                      selectedKeywords.add(keyword);
                    } else {
                      selectedKeywords.remove(keyword);
                    }
                  });
                  debugPrint('Selected Keywords: $selectedKeywords');
                  widget.onKeywordsSelected(selectedKeywords);
                },
                options: GroupButtonOptions(
                  selectedTextStyle: const TextStyle(
                    color: Colors.white, // 선택된 텍스트 색상
                  ),
                  selectedColor: blueColor1, // 선택된 버튼 배경 색상
                  unselectedColor: Colors.white, // 선택되지 않은 버튼 배경 색상
                  unselectedTextStyle: const TextStyle(
                    color: blueColor1, // 선택되지 않은 텍스트 색상
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
