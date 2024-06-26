class UserImage {
  int imageNumber;
  int userNumber;
  String imagePath;
  DateTime imageCreated;
  String imageKey;

  UserImage({
    required this.imageNumber,
    required this.userNumber,
    required this.imagePath,
    required this.imageCreated,
    required this.imageKey,
  });

  // Dart 객체 -> JSON
  Map<String, dynamic> toJson() {
    return {
      'imageNumber': imageNumber,
      'userNumber': userNumber,
      'imagePath': imagePath,
      'imageCreated': imageCreated.toIso8601String(),
      'imageKey': imageKey,
    };
  }

  // JSON -> Dart 객체
  factory UserImage.fromJson(Map<String, dynamic> json) {
    return UserImage(
      imageNumber: json['imageNumber'],
      userNumber: json['userNumber'],
      imagePath: json['imagePath'],
      imageCreated: DateTime.parse(json['imageCreated']),
      imageKey: json['imageKey'],
    );
  }
}
