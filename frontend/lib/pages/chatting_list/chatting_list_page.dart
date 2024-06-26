import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend_matching/controllers/chatting_controller.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/pages/chatting_list/chatlist_listtile.dart';
import 'package:frontend_matching/controllers/chatting_list_controller.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/text_style.dart';
import 'package:get/get.dart';

class ChattingListPage extends StatelessWidget {
  const ChattingListPage({super.key});

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ChattingListController.getLastChatList(); // 마지막 채팅 내역 가져오기
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("채팅"),
          ],
        ),
      ),
      body: Obx(
        () => ChattingListController.to.chattingList.isEmpty ? const Center(child: Text("텅...",style: greyTextStyle3,),) :

            ListView.separated(
          itemCount: ChattingListController.to.chattingList.length,
          itemBuilder: (context, index) {
            var chatListData = ChattingListController.to.chattingList[index];
            return Slidable(
              key: ValueKey(chatListData.roomId),
              endActionPane: ActionPane(
                extentRatio: 0.25,
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.output,
                    label: '나가기',
                    onPressed: (BuildContext context) async {
                      // 친구가 아닌 채팅창 => 요청을 받은 친구 or 요청을 보낸 친구 채팅방
                      if (chatListData.isChatEnabled == false) {
                        // 받은 요청일 경우
                        if (chatListData.isReceivedRequest == true) {
                          Get.dialog(
                            AlertDialog(
                              title: const Text('채팅방 나가기'),
                              content: const Text(
                                '채팅방을 나갈 경우 받은 친구 요청을 거절하게 됩니다. 채팅방을 나가시겠어요?',
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('취소',
                                      style: TextStyle(color: Colors.black)),
                                  onPressed: () => Get.back(),
                                ),
                                TextButton(
                                  child: const Text('나가기',
                                      style: TextStyle(color: Colors.red)),
                                  onPressed: () async {
                                    await FriendController.rejectFriendRequest(
                                        requestId: chatListData.friendRequestId
                                            !);
                                    await ChattingListController
                                        .getLastChatList();
                                    await FriendController.getFriendReceivedRequest();
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                        // 보낸 요청일 경우
                        else {
                          Get.dialog(
                            AlertDialog(
                              title: const Text('채팅방 나가기'),
                              content: const Text(
                                '채팅방을 나갈 경우 보낸 친구 요청을 취소하게 됩니다. 채팅방을 나가시겠어요?',
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('취소',
                                      style: TextStyle(color: Colors.black)),
                                  onPressed: () => Get.back(),
                                ),
                                TextButton(
                                  child: const Text('나가기',
                                      style: TextStyle(color: Colors.red)),
                                  onPressed: () async {
                                    await FriendController.deleteFriendRequest(
                                        requestId: chatListData.friendRequestId
                                            .toString());
                                    await ChattingListController
                                        .getLastChatList();
                                    await FriendController.getFriendSentRequest();
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      // 친구와 채팅일 경우
                      else {
                        Get.dialog(
                          AlertDialog(
                            title: const Text('채팅방 나가기'),
                            content: const Text(
                              '채팅방을 나가시겠어요?',
                            ),
                            actions: [
                              TextButton(
                                child: const Text('취소',
                                    style: TextStyle(color: Colors.black)),
                                onPressed: () => Get.back(),
                              ),
                              TextButton(
                                child: const Text('나가기',
                                    style: TextStyle(color: Colors.red)),
                                onPressed: () async {
                                  await ChattingListController.leaveRoom(
                                      roomId: chatListData.roomId);
                                  await ChattingListController
                                      .getLastChatList();
                                  Get.back();
                                  FriendController.getFriendList();
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              child: ChatListTile(
                chatListData: chatListData,
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 5,
            );
          },
        ),
      ),
    );
  }
}
