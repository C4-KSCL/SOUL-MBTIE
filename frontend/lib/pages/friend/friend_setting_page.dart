import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/friend/friend_setting_page_tab_view.dart';
import 'package:frontend_matching/theme/text_style.dart';
import 'package:get/get.dart';

import '../../controllers/friend_controller.dart';
import '../../theme/colors.dart';

class FriendSettingPage extends StatelessWidget {
  FriendSettingPage({super.key});

  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FriendController.to.friends.clear();
      FriendController.to.blockedFriends.clear();
      FriendController.getFriendList();
      FriendController.getBlockedFriendList();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("친구 관리"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
                decoration: BoxDecoration(
                  color: greyColor3,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: FriendController.to.pageNumber.value == 0
                                  ? whiteColor1
                                  : greyColor3,
                              borderRadius: BorderRadius.circular(8)),
                          width: 150,
                          child: TextButton(
                              onPressed: () {
                                FriendController.to.pageNumber.value = 0;
                                _carouselController.jumpToPage(
                                    FriendController.to.pageNumber.value);
                              },
                              child: Text(
                                '친구 관리',
                                style: FriendController.to.pageNumber.value == 0
                                    ? blueTextStyle2
                                    : greyTextStyle5,
                              )),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: FriendController.to.pageNumber.value == 1
                                ? whiteColor1
                                : greyColor3,
                            borderRadius: BorderRadius.circular(8)),
                        width: 150,
                        child: TextButton(
                          onPressed: () {
                            FriendController.to.pageNumber.value = 1;
                            _carouselController.jumpToPage(
                                FriendController.to.pageNumber.value);
                          },
                          child: Text(
                            '차단 친구 관리',
                            style: FriendController.to.pageNumber.value == 1
                                ? blueTextStyle2
                                : greyTextStyle5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          // 탭 뷰
          CarouselSlider(
            carouselController: _carouselController,
            items: [
              settingFriendTabView(),
              settingBlockedFriendTabView(),
            ],
            options: CarouselOptions(
                height: Get.height * 0.7,
                scrollDirection: Axis.horizontal,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                initialPage: FriendController.to.pageNumber.value,
                onPageChanged: (index, reason) {
                  FriendController.to.pageNumber.value =
                      index; // 현재 페이지 인덱스를 _pageNumber 변수에 할당
                }),
          ),
        ],
      ),
    );
  }
}
