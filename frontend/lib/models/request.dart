class Request {
  final int requestId;
  final String userEmail;
  final String myMBTI;
  final String myKeyword;
  final String nickname;
  final String userImage;
  final String age;
  final String gender;
  final String createdAt;
  final String roomId;

  Request({
    required this.requestId,
    required this.userEmail,
    required this.myMBTI,
    required this.myKeyword,
    required this.nickname,
    required this.userImage,
    required this.age,
    required this.gender,
    required this.createdAt,
    required this.roomId,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      requestId: json['requestId'],
      userEmail: json['userEmail'],
      myMBTI: json['myMBTI'],
      myKeyword: json['myKeyword'],
      nickname: json['nickname'],
      userImage: json['userImage'],
      age: json['age'],
      gender: json['gender'],
      createdAt: json['createdAt'],
      roomId: json['roomId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'userEmail':userEmail,
      'myMBTI': myMBTI,
      'myKeyword': myKeyword,
      'nickname': nickname,
      'userImage': userImage,
      'age': age,
      'gender':gender,
      'createdAt': createdAt,
      'roomId': roomId,
    };
  }
}