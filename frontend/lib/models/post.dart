class Post {
  final int postNumber;
  final int userNumber;
  final String category;
  final String title;
  final String content;
  final String createdTime;
  final int isAnswered;
  final int? responderNumber;
  final String? responseTitle;
  final String? responseContent;
  final String? responseTime;

  Post({
    required this.postNumber,
    required this.userNumber,
    required this.category,
    required this.title,
    required this.content,
    required this.createdTime,
    required this.isAnswered,
    this.responderNumber,
    this.responseTitle,
    this.responseContent,
    this.responseTime,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postNumber: json['postNumber'],
      userNumber: json['userNumber'],
      category: json['postCategory'],
      title: json['postTitle'],
      content: json['postContent'],
      createdTime: json['createdTime'],
      isAnswered: json['isAnswered'],
      responderNumber: json['responderNumber'],
      responseTitle: json['responseTitle'],
      responseContent: json['responseContent'],
      responseTime: json['responseTime'],
    );
  }
}
