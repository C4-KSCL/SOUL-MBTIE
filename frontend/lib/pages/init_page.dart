// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/matching/find_friend_page.dart';
import 'package:frontend_matching/pages/profile/my_page.dart';
import 'package:get/get.dart';
import '../components/my_navigator_bar.dart';
import '../controllers/bottom_nav_controller.dart';
import 'chatting_list/chatting_list_page.dart';
import 'friend/friend_page.dart';
import 'matching/main_page.dart';

class InitPage extends StatelessWidget {
  const InitPage({Key? key}) : super(key: key);

  //탭별 페이지 정의
  static List<Widget> tabPages = <Widget>[
    FindFriendsPage(),
    FriendPage(),
    ChattingListPage(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SafeArea(
            child:
                // static 변수를 이용해 컨트롤러 접근
                tabPages[BottomNavigationBarController.to.selectedIndex.value]),
      ),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}
