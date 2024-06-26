import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/chatting_controller.dart';
import 'package:frontend_matching/controllers/chatting_list_controller.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/text_style.dart';
import 'package:get/get.dart';

Widget AcceptOrRejectButtonLayer(int? friendRequestId) {
  return Container(
    width: 320,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 150,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: blueColor1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // 둥근 모서리의 반지름
              ),
            ),
            onPressed: () async{
              //친구 수락
              await FriendController.acceptFriendRequest(requestId: friendRequestId!);
              await FriendController.getFriendList();
              await FriendController.getFriendReceivedRequest();
              ChattingController.to.isChatEnabled.value=true;
            },
            child: const Text(
              "수락",
              style: blackTextStyle2,
            ),
          ),
        ),
        SizedBox(
          width: 150,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: pinkColor1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // 둥근 모서리의 반지름
              ),
            ),
            onPressed: () async {
              // 친구 거절
              await FriendController.rejectFriendRequest(requestId: friendRequestId!);
              await FriendController.getFriendReceivedRequest();
              Get.back();
            },
            child: const Text(
              "거절",
              style: blackTextStyle2,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget CancelButtonLayer(int? friendRequestId) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
    ),
    child: TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // 둥근 모서리의 반지름
        ),
      ),
      onPressed: () async {
        ChattingController.to.disconnect();
        await FriendController.deleteFriendRequest(requestId: friendRequestId.toString());
        await FriendController.getFriendSentRequest();
        await ChattingListController.getLastChatList();
        Get.back();
      },
      child: const Text(
        "취소",
        style: blackTextStyle2,
      ),
    ),
  );
}
