import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/chat_list.dart';
import 'package:get/get.dart';

import '../config.dart';

class ChattingListController extends GetxController {
  static ChattingListController get to => Get.find<ChattingListController>();

  static String? baseUrl = AppConfig.baseUrl;

  RxList<ChatList> chattingList = <ChatList>[].obs; //채팅 리스트

  // 채팅 리스트 비우기
  void resetData() {
    chattingList.clear();
  }

  //유저의 마지막 채팅들 가져오기 - 채팅방 리스트 구현
  static Future<void> getLastChatList() async {
    final url = Uri.parse('$baseUrl/chats/get-last-chats');
    List<ChatList> tempChatList = [];

    var response = await UserDataController.sendHttpRequestWithTokenManagement(method: 'get', url: url);

    print(response.statusCode);

    if (response.statusCode == 200) {
      var lastChats = jsonDecode(response.body);
      print(response.body);
      print(UserDataController.to.accessToken);
      if (lastChats['lastChats'] != null) {
        for (var lastChat in lastChats['lastChats']) {
          String roomId = lastChat['roomId'];
          String userEmail = lastChat['userEmail'] ??= "삭제된 유저";
          String createdAt = lastChat['createdAt'];
          String content = lastChat['content'];
          String type = lastChat['type'];
          int friendRequestId = lastChat['room']['addRequest'].isNotEmpty
              ? lastChat['room']['addRequest'][0]['id']
              : -1;
          int notReadCounts = lastChat['notReadCounts'];
          bool isChatEnabled = lastChat['room']['publishing'] == "true";
          bool isReceivedRequest = lastChat['room']['addRequest'].isEmpty
              ? false
              : lastChat['room']['addRequest'][0]['reqUser'] !=
                  UserDataController.to.user.value!.email;

          String nickname = "";
          String userImage = "";

          if (lastChat['room']['joinRoom'].isNotEmpty) {
            nickname = lastChat['room']['joinRoom'][0]['user']['nickname'];
            userImage = lastChat['room']['joinRoom'][0]['user']['userImage'];
          } else if (lastChat['room']['joinRoom'].isEmpty &&
              lastChat['room']['addRequest'].isEmpty) {
            nickname = "삭제된 유저";
            userImage =
                "https://matchingimage.s3.ap-northeast-2.amazonaws.com/defalut_user.png";
          }

          var chatList = ChatList(
            roomId: roomId,
            userEmail: userEmail,
            nickname: nickname,
            createdAt: createdAt,
            content: content,
            type: type,
            notReadCounts: notReadCounts,
            friendRequestId: friendRequestId,
            userImage: userImage,
            isChatEnabled: isChatEnabled,
            isReceivedRequest: isReceivedRequest,
          );

          tempChatList.add(chatList);
        }
      }
      ChattingListController.to.chattingList.assignAll(tempChatList);
    }
  }

  /// 채팅 방 나가기
  static Future<void> leaveRoom({
    required String roomId,
  }) async {
    final url = Uri.parse('$baseUrl/rooms/leave/$roomId');

    var response = await UserDataController.sendHttpRequestWithTokenManagement(method: 'patch', url: url,);

    if (response.statusCode == 200) {
      print("${response.statusCode} 성공적으로 나가짐");
    } else {
      print("나가기 실패");
      print(response.body);

    }
  }

  /// 채팅방 참가하기
  static Future<void> rejoinRoom({
    required String oppEmail,
  }) async {
    final url = Uri.parse('$baseUrl/rooms/create');

    final body = jsonEncode({"oppEmail": oppEmail});

    var response = await UserDataController.sendHttpRequestWithTokenManagement(method: 'patch', url: url, body: body);

    print(response.statusCode);
    print(response.body);
  }
}
