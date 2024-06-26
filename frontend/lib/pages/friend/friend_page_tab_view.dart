import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/friend/friend_and_request_listtile.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:frontend_matching/theme/text_style.dart';
import 'package:get/get.dart';

Widget friendTabView() {
  return Obx(() => FriendController.to.friends.isEmpty ? const Center(child: Text("텅...",style: greyTextStyle3,),) : ListView.separated(
        itemCount: FriendController.to.friends.length,
        itemBuilder: (context, index) {
          var friendData = FriendController.to.friends[index];
          return friendListTile(
            friendData: friendData,
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 5,);
        },
      ));
}

Widget receivedFriendRequestTabView() {
  return Obx(() => FriendController.to.receivedRequests.isEmpty ? const Center(child: Text("텅...",style: greyTextStyle3,),) : ListView.separated(
    itemCount: FriendController.to.receivedRequests.length,
    itemBuilder: (context, index) {
      var receivedRequestData = FriendController.to.receivedRequests[index];
      return receivedRequestListTile(
        receivedRequestData: receivedRequestData,
      );
    },
    separatorBuilder: (context, index) {
      return const SizedBox(height: 5,);
    },
  ));
}

Widget sentFriendRequestTabView() {
  return Obx(() => FriendController.to.sentRequests.isEmpty ? const Center(child: Text("텅...",style: greyTextStyle3,),) :ListView.separated(
    itemCount: FriendController.to.sentRequests.length,
    itemBuilder: (context, index) {
      var sentRequestData=FriendController.to.sentRequests[index];
      return sentRequestListTile(
        sentRequestData: sentRequestData,
      );
    },
    separatorBuilder: (context, index) {
      return const SizedBox(height: 5,);
    },
  )) ;
}
