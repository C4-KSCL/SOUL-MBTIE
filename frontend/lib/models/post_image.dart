class PostImage {
  final int postNumber;
  final int imageNumber;
  final String imagePath;
  final String imageKey;
  final String imageCreatedTime;

  PostImage({
    required this.postNumber,
    required this.imageNumber,
    required this.imagePath,
    required this.imageKey,
    required this.imageCreatedTime,
  });

  factory PostImage.fromJson(Map<String, dynamic> json) {
    return PostImage(
      postNumber: json['postNumber'],
      imageNumber: json['imageNumber'],
      imagePath: json['imagePath'],
      imageKey: json['imageKey'],
      imageCreatedTime: json['imageCreatedTime'],
    );
  }
}
