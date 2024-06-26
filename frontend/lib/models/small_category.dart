class SmallCategory {
  final int id;
  final String name;
  final String bigName;
  final String selectOne; // 첫번째 답변
  final String selectTwo; // 두번째 답변
  final String content;
  final int? imageId;
  final EventImage? eventImage;

  SmallCategory({
    required this.id,
    required this.name,
    required this.bigName,
    required this.selectOne,
    required this.selectTwo,
    required this.content,
    required this.imageId,
    required this.eventImage,
  });

  // JSON에서 SmallModel 객체로 변환하는 팩토리 생성자
  factory SmallCategory.fromJson(Map<String, dynamic> json) {
    return SmallCategory(
      id: json['id'],
      name: json['name'],
      bigName: json['bigName'],
      selectOne: json['selectOne'],
      selectTwo: json['selectTwo'],
      content: json['content'],
      imageId: json['imageId'],
      eventImage: json['eventImage'] != null ? EventImage.fromJson(json['eventImage']) : null,
    );
  }

  // SmallModel 객체에서 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bigName': bigName,
      'selectOne': selectOne,
      'selectTwo': selectTwo,
      'content':content,
      'imageId': imageId,
      'eventImage' : eventImage,
    };
  }
}

class EventImage {
  final String filepath;

  EventImage({required this.filepath});

  factory EventImage.fromJson(Map<String, dynamic> json) {
    return EventImage(
      filepath: json['filepath'],
    );
  }
}