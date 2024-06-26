import 'package:frontend_matching/models/event.dart';
import 'package:get/get.dart';

class Chat {
  final int id;
  final String roomId;
  final String? nickName;
  final String? userEmail;
  final String createdAt;
  final Rx<String> content;
  final Rx<int> readCount;
  final String type;
  final Event? event;
  Rx<bool> isVisibleDate;

  Chat({
    required this.id,
    required this.roomId,
    this.nickName,
    this.userEmail,
    required this.createdAt,
    required String content,
    required int readCount,
    required this.type,
    this.event,
    bool isVisibleDate = true,  // 기본값 설정
  }) : readCount = readCount.obs,
        content = content.obs,
        isVisibleDate = isVisibleDate.obs;  // Rx 타입은 .obs로 감싸줘야 한다.

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      roomId: json['roomId'],
      nickName: json['nickName'],
      userEmail: json['userEmail'],
      createdAt: json['createdAt'],
      content: json['content'],
      readCount: json['readCount'],
      type: json['type'],
      event: json['event'] != null ? Event.fromJson(json['event']) : null,
      // isVisibleDate는 기본값을 사용하므로 특별히 지정하지 않음
    );
  }
}
