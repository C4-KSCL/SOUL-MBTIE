class ChatList {
  final String roomId;
  String? userEmail;
  String? nickname;
  String createdAt;
  String content;
  String type;
  int notReadCounts;
  int? friendRequestId;
  String userImage;
  bool isChatEnabled;
  bool isReceivedRequest;

  ChatList({
    required this.roomId,
    required this.userEmail,
    this.nickname,
    required this.createdAt,
    required this.content,
    required this.type,
    required this.notReadCounts,
    this.friendRequestId,
    required this.userImage,
    this.isChatEnabled = false,
    this.isReceivedRequest = false,
  });

  factory ChatList.fromJson(Map<String, dynamic> json) {
    return ChatList(
      roomId: json['roomId'],
      userEmail: json['userEmail'],
      nickname: json['nickname'],
      // 키 값을 올바르게 수정
      createdAt: json['createdAt'],
      content: json['content'],
      type: json['type'],
      notReadCounts: json['notReadCounts'],
      friendRequestId: json['friendRequestId'],
      userImage: json['userImage'],
      isChatEnabled: json['isChatEnabled'] ?? false,
      // JSON에 없는 경우 기본값 사용
      isReceivedRequest:
          json['isReceivedRequest'] ?? false, // JSON에 없는 경우 기본값 사용
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'userEmail':userEmail,
      'nickname': nickname,
      'createdAt': createdAt,
      'content': content,
      'type':type,
      'notReadCounts': notReadCounts,
      'friendRequestId':friendRequestId,
      'userImage': userImage,
      'isChatEnabled': isChatEnabled,
      'isReceivedRequest': isReceivedRequest,
    };
  }
}
