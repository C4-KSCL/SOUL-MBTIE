import 'package:flutter/material.dart';
import 'package:frontend_matching/models/big_category.dart';
import 'package:frontend_matching/controllers/chatting_controller.dart';
import 'package:frontend_matching/theme/text_style.dart';
import 'package:get/get.dart';

Widget bigCategory() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Opacity(
            // 투명한 IconButton을 추가하여 균형을 맞춤
            opacity: 0.0, // 완전 투명
            child: IconButton(
              onPressed: null, // 아무 동작도 하지 않음
              icon: Icon(Icons.close), // 실제 아이콘과 동일한 아이콘 사용
            ),
          ),
          const Expanded(
            // Text를 중앙 정렬하기 위해 Expanded 사용
            child: Text(
              "밸런스 게임 보내기",
              style: blackTextStyle2,
              textAlign: TextAlign.center, // Text 중앙 정렬
            ),
          ),
          IconButton(
            // 실제 사용할 IconButton
            onPressed: () {
              ChattingController.to.clickAddButton.value = false;
              ChattingController.to.clickQuizButtonIndex.value = -1;
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      Expanded(
        child: FutureBuilder(
          future: ChattingController.getBigCategories(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 데이터를 기다리는 동안 로딩 인디케이터를 보여줌
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // 에러 발생 시
              return Text("Error: ${snapshot.error}");
            } else {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: ChattingController.to.bigCategories.length,
                itemBuilder: (context, index) {
                  BigCategory bigCategory =
                      ChattingController.to.bigCategories[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            // 모양 설정
                            borderRadius:
                                BorderRadius.circular(10), // 둥근 모서리의 반지름
                          ),
                          minimumSize: Size(Get.width * 0.3, 30),
                        ),
                        onPressed: () {
                          ChattingController.to.bigCategoryName =
                              bigCategory.name;
                          ChattingController.to.showSecondGridView.value = true;
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Image.network(

                              bigCategory.eventImage!.filepath,
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              bigCategory.name,
                              style: blackTextStyle2,
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    ],
  );
}
