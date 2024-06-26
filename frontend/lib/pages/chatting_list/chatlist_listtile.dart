import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/controllers/chatting_controller.dart';
import 'package:frontend_matching/services/time_convert_service.dart';
import 'package:get/get.dart';

import '../../models/chat_list.dart';
import '../../services/text_service.dart';
import '../../theme/text_style.dart';
import '../chatting_room/chatting_room_page.dart';

Widget ChatListTile({
  required ChatList chatListData,
}) {
  return ListTile(
    key: ValueKey(chatListData.roomId),
    leading: ClipRRect(
      borderRadius: BorderRadius.circular(8.0), // 모서리를 둥글게 처리
      child: Image.network(
        chatListData.userImage,
        width: 50,
        height: 100,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            );
          }
        },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return
            Image.asset(
              'assets/icons/defalut_user.png',
              width: 50,
              height: 100,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            );
        },
      ),
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          chatListData.nickname ??= "알 수 없음",
          style: blackTextStyle1,
        ),
        Text(
          summarizeText(chatListData.content),
          style: greyTextStyle3,
        ),
      ],
    ),
    trailing: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          convertHowMuchTimeAge(utcTimeString: chatListData.createdAt),
          style: greyTextStyle4,
        ),
        const SizedBox(
          height: 10,
        ),
        if (chatListData.notReadCounts != 0)
          Container(
            decoration: BoxDecoration(
              color: chatListData.userEmail ==
                      UserDataController.to.user.value!.email
                  ? Colors.transparent
                  : Colors.red,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              child: Text(
                chatListData.userEmail ==
                        UserDataController.to.user.value!.email
                    ? ""
                    : chatListData.notReadCounts.toString(),
                style: whiteTextStyle2,
              ),
            ),
          ),
      ],
    ),
    onTap: () {
      print("받은 요청인가? : ${chatListData.isReceivedRequest}");
      print("챗 가능 : ${chatListData.isChatEnabled}");

      Get.to(() => ChatRoomPage(
            friendRequestId: chatListData.friendRequestId,
            roomId: chatListData.roomId,
            oppUserName: chatListData.nickname ??= "알 수 없음",
            isChatEnabled: chatListData.isChatEnabled,
            isReceivedRequest: chatListData.isReceivedRequest,
          ));
    },
  );
}
