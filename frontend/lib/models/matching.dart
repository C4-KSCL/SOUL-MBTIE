import 'dart:convert';

class Data {
  final List<MatchingUser> users;
  final List<MatchingImage> images;

  Data({required this.users, required this.images});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      users: List<MatchingUser>.from(
          json["users"].map((x) => MatchingUser.fromJson(x))),
      images: List<MatchingImage>.from(
          json["images"].map((x) => MatchingImage.fromJson(x))),
    );
  }
}

// 사용자 정보를 담을 클래스
class MatchingUser {
  final int userNumber;
  final String email;
  final String password;
  final String nickname;
  final String phoneNumber;
  final String age;
  final String gender;
  final String myMBTI;
  final String friendMBTI;
  final String myKeyword;
  final String friendKeyword;
  final String userCreated;
  final int suspend;
  final int manager;
  final String friendGender;
  final String friendMaxAge;
  final String friendMinAge;
  final String requestTime;
  final String userImage;
  final String userImageKey;
  final String analysis;
  MatchingUser({
    required this.userNumber,
    required this.email,
    required this.password,
    required this.nickname,
    required this.phoneNumber,
    required this.age,
    required this.gender,
    required this.myMBTI,
    required this.friendMBTI,
    required this.myKeyword,
    required this.friendKeyword,
    required this.userCreated,
    required this.suspend,
    required this.manager,
    required this.friendGender,
    required this.friendMaxAge,
    required this.friendMinAge,
    required this.requestTime,
    required this.userImage,
    required this.userImageKey,
    required this.analysis,
  });

  factory MatchingUser.fromJson(Map<String, dynamic> json) => MatchingUser(
        userNumber: json["userNumber"],
        email: json["email"],
        password: json["password"],
        nickname: json["nickname"],
        phoneNumber: json["phoneNumber"],
        age: json["age"],
        gender: json["gender"],
        myMBTI: json["myMBTI"],
        friendMBTI: json["friendMBTI"],
        myKeyword: json["myKeyword"],
        friendKeyword: json["friendKeyword"],
        userCreated: json["userCreated"],
        suspend: json["suspend"],
        manager: json["manager"],
        friendGender: json["friendGender"],
        friendMaxAge: json["friendMaxAge"],
        friendMinAge: json["friendMinAge"],
        requestTime: json["requestTime"],
        userImage: json["userImage"],
        userImageKey: json["userImageKey"],
        analysis: json["analysis"],
      );
}

class MatchingImage {
  final int imageNumber;
  final int userNumber;
  final String imagePath;
  final String imageCreated;

  MatchingImage({
    required this.imageNumber,
    required this.userNumber,
    required this.imagePath,
    required this.imageCreated,
  });

  factory MatchingImage.fromJson(Map<String, dynamic> json) => MatchingImage(
        imageNumber: json["imageNumber"],
        userNumber: json["userNumber"],
        imagePath: json["imagePath"],
        imageCreated: json["imageCreated"],
      );
}

Data parseData(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return Data.fromJson(parsed);
}
