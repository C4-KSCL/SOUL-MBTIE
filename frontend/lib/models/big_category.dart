class BigCategory {
  final String name;
  final int? imageId;
  final EventImage? eventImage;

  BigCategory({
    required this.name,
    this.imageId,
    this.eventImage,
  });

  factory BigCategory.fromJson(Map<String, dynamic> json) {
    return BigCategory(
      name: json['name'],
      imageId: json['imageId'],
      eventImage: json['eventImage'] != null ? EventImage.fromJson(json['eventImage']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageId': imageId,
      'eventImage': eventImage?.toJson(),
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

  Map<String, dynamic> toJson() {
    return {
      'filepath': filepath,
    };
  }
}