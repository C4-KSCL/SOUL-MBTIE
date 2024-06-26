import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/friend/friend_and_request_listtile.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:get/get.dart';

Widget settingFriendTabView() {
  return Obx(() => ListView.separated(
    itemCount: FriendController.to.friends.length,
    itemBuilder: (context, index) {
      var friendData = FriendController.to.friends[index];
      return friendSettingListTile(friendData: friendData);
    },
    separatorBuilder: (context, index) {
      return const SizedBox(height: 5,);
    },
  ));
}

Widget settingBlockedFriendTabView() {
  return Obx(() => ListView.separated(
    itemCount: FriendController.to.blockedFriends.length,
    itemBuilder: (context, index) {
      var friendData = FriendController.to.blockedFriends[index];
      return blockedFriendSettingListTile(
        friendData: friendData,
      );
    },
    separatorBuilder: (context, index) {
      return const SizedBox(height: 5,);
    },
  ));
}