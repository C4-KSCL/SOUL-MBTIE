import 'package:flutter/material.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';

import '../controllers/bottom_nav_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyBottomNavigationBar extends GetView<BottomNavigationBarController> {
  const MyBottomNavigationBar({super.key});

  //controller는 GetView<BottomNavigationBarController>때문에 자동으로 BottomNavigationBarController을 할당

  @override
  Widget build(BuildContext context) {
    //Obx()안에서 .obs인 변수가 변화되면 위젯을 다시 빌드해서 화면 업데이트
    return Obx(() => BottomNavigationBar(
          // 현재 인덱스를 selectedIndex에 저장
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          unselectedItemColor: Colors.black, //애니메이션 없음
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: controller.selectedIndex.value == 0
                  ? SvgPicture.asset(
                      'assets/icons/home.svg',
                      color: blueColor1,
                    )
                  : SvgPicture.asset('assets/icons/home.svg'),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: controller.selectedIndex.value == 1
                  ? SvgPicture.asset(
                      'assets/icons/friend.svg',
                      color: blueColor1,
                    )
                  : SvgPicture.asset('assets/icons/friend.svg'),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: controller.selectedIndex.value == 2
                  ? SvgPicture.asset(
                      'assets/icons/message.svg',
                      color: blueColor1,
                    )
                  : SvgPicture.asset('assets/icons/message.svg'),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: controller.selectedIndex.value == 3
                  ? SvgPicture.asset(
                      'assets/icons/my_information.svg',
                      color: blueColor1,
                    )
                  : SvgPicture.asset('assets/icons/my_information.svg'),
              label: '',
            ),
          ],
        ));
  }
}
