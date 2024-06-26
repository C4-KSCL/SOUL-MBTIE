class Friend {
  final int id;
  final String userEmail; // 사용자 이메일
  final String oppEmail; // 친구 이메일
  final String myMBTI; //친구 mbti
  final String myKeyword; //친구 키워드
  final String nickname; // 친구 닉네임
  final String userImage; //친구 프로필 이미지
  final String age; // 친구 나이
  final String gender; // 친구 성별
  final String? roomId; // 친구와 연결된 채팅방 id
  final bool? isJoinRoom;

  Friend({
    required this.id,
    required this.userEmail,
    required this.oppEmail,
    required this.myMBTI,
    required this.myKeyword,
    required this.nickname,
    required this.userImage,
    required this.age,
    required this.gender,
    this.roomId,
    this.isJoinRoom,
  });
}
