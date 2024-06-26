class User {
  int? userNumber; //회원번호
  String email; //이메일
  String password; //비밀번호
  String nickname; //닉네임
  String phoneNumber;
  String age;
  String gender; //성별
  String? myMBTI; //회원의 MBTI
  String? myKeyword; //회원에게 해당되는 키워드
  String? friendMBTI; //친구로 원하는 MBTI
  String? friendKeyword; //친구로 원하는 키워드
  String? friendMaxAge;
  String? friendMinAge;
  String? friendGender;
  DateTime? userCreated; //회원가입한 날짜
  String? userImage;
  String? userImageKey;
  DateTime? requestTime;
  int? suspend;
  int? manager;
  String? analysis;

  User({
    required this.userNumber,
    required this.email,
    required this.password,
    required this.nickname,
    required this.phoneNumber,
    required this.age,
    required this.gender,
    this.myMBTI,
    this.friendMBTI,
    this.myKeyword,
    this.friendKeyword,
    this.userCreated,
    this.friendGender,
    this.friendMaxAge,
    this.friendMinAge,
    this.userImage,
    this.userImageKey,
    this.requestTime,
    this.manager,
    this.suspend,
    this.analysis,
  });

  //Dart 객체 -> JSON
  Map<String, dynamic> toJson() {
    return {
      'userNumber': userNumber,
      'email': email,
      'password': password,
      'nickname': nickname,
      'phoneNumber': phoneNumber,
      'age': age,
      'gender': gender,
      'myMBTI': myMBTI,
      'friendMbti': friendMBTI,
      'myKeyword': myKeyword,
      'friendKeyword': friendKeyword,
      'userCreated': userCreated?.toIso8601String(),
      'friendGender': friendGender,
      'friendMaxAge': friendMaxAge,
      'friendMinAge': friendMinAge,
      'userImage': userImage,
      'userImageKey': userImageKey,
      'requestTime': requestTime,
      'suspend': suspend,
      'manager': manager,
      'analysis': analysis,
    };
  }

  //JSON -> Dart 객체
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userNumber: json['userNumber'],
      email: json['email'],
      password: json['password'],
      nickname: json['nickname'],
      phoneNumber: json['phoneNumber'],
      age: json['age'],
      gender: json['gender'],
      myMBTI: json['myMBTI'],
      friendMBTI: json['friendMBTI'],
      myKeyword: json['myKeyword'],
      friendKeyword: json['friendKeyword'],
      userCreated: DateTime.tryParse(json['userCreated']),
      friendGender: json['friendGender'],
      friendMaxAge: json['friendMaxAge'],
      friendMinAge: json['friendMinAge'],
      userImage: json['userImage'],
      userImageKey: json['userImageKey'],
      requestTime: DateTime.tryParse(json['requestTime']),
      suspend: json['suspend'],
      manager: json['manager'],
      analysis: json['analysis'],
    );
  }
}
