import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/find_friend_controller.dart';
import 'package:frontend_matching/pages/matching/loading_page.dart';
import 'package:frontend_matching/pages/matching/main_page.dart';
import 'package:get/get.dart';

class FindFriendsPage extends StatefulWidget {
  @override
  _FindFriendsPageState createState() => _FindFriendsPageState();
}

class _FindFriendsPageState extends State<FindFriendsPage> {
  @override
  void initState() {
    super.initState();
    if (FindFriendController.to.matchingFriendInfoList.isEmpty &&
        !FindFriendController.to.isLoading.value) {
      FindFriendController.findFriends();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (FindFriendController.to.isLoading.value) {
          return const LoadingPage();
        } else if (FindFriendController.to.matchingFriendInfoList.isEmpty) {
          return const LoadingPage();
        } else {
          return const MainPage();
        }
      }),
    );
  }
}
