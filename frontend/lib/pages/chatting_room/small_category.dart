import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend_matching/models/small_category.dart';
import 'package:frontend_matching/controllers/chatting_controller.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/text_style.dart';
import 'package:get/get.dart';

Widget smallCategory() {
  // 두 번째 GridView.builder를 구성하는 코드
  // 여기서는 단순화를 위해 동일한 구조를 사용했으나, 필요에 따라 다르게 구성할 수 있습니다.

  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              ChattingController.to.showSecondGridView.value = false;
              ChattingController.to.clickQuizButtonIndex.value = -1;

            },
            icon: const Icon(Icons.keyboard_arrow_left),
          ),
          Expanded(
            child: Text(
              ChattingController.to.bigCategoryName!,
              style: blackTextStyle2,
              textAlign: TextAlign.center,
            ),
          ),
          const Opacity(
            // 투명한 IconButton을 추가하여 균형을 맞춤
            opacity: 0.0, // 완전 투명
            child: IconButton(
              onPressed: null, // 아무 동작도 하지 않음
              icon: Icon(Icons.close), // 실제 아이콘과 동일한 아이콘 사용
            ),
          ),
        ],
      ),
      Expanded(
        child: FutureBuilder(
            future: ChattingController.getSmallCategories(bigCategoryName: ChattingController.to.bigCategoryName!),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // 데이터를 기다리는 동안 로딩 인디케이터를 보여줌
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // 에러 발생 시
                return Text("Error: ${snapshot.error}");
              } else {
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: ChattingController.to.smallCategories.length,
                    // 예시를 위해 아이템 개수를 9개로 설정
                    itemBuilder: (context, index) {
                      SmallCategory smallCategory =
                          ChattingController.to.smallCategories[index];
                      return Obx(() => Padding(
                            padding: const EdgeInsets.all(10),
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // 둥근 모서리의 반지름
                                      ),
                                      minimumSize: Size(Get.width * 0.3, 30),
                                    ),
                                    onPressed: () {
                                      ChattingController.to
                                          .clickQuizButton(index);
                                    },
                                    child: Text(
                                      smallCategory.name,
                                      style: blackTextStyle2,
                                    ),
                                  ),
                                ),
                                if (ChattingController
                                        .to.clickQuizButtonIndex.value ==
                                    index)
                                  SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                            Colors.white.withOpacity(0.5),
                                        shape: RoundedRectangleBorder(
                                          // 모양 설정
                                          borderRadius: BorderRadius.circular(
                                              10), // 둥근 모서리의 반지름
                                        ),
                                        minimumSize: Size(Get.width * 0.3, 30),
                                      ),
                                      onPressed: () {
                                        print("전송 클릭");
                                        //event message 전송
                                        ChattingController.to.newEvent(
                                            smallCategoryName:
                                                smallCategory.name);
                                        ChattingController.to.clickQuizButtonIndex.value=-1;
                                      },
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        // 하단 정렬
                                        children: [
                                          Spacer(), // 상단에 공간을 추가하여 텍스트를 밀어내림
                                          Text(
                                            "전송",
                                            style: blueTextStyle1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ));
                    });
              }
            }),
      ),
    ],
  );
}
