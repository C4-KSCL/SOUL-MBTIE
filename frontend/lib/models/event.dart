import 'package:frontend_matching/models/small_category.dart';
import 'package:get/get.dart';

class Event {
  final int id;
  final int chattingId;
  final int category;
  final String? user1;
  final String? user2;
  final Rx<String?> user1Choice;
  final Rx<String?> user2Choice;
  final String createdAt;
  final SmallCategory smallCategory;

  Event({
    required this.id,
    required this.chattingId,
    required this.category,
    required this.user1,
    required this.user2,
    String? user1Choice,
    String? user2Choice,
    required this.createdAt,
    required this.smallCategory,
  }) : user1Choice = Rx<String?>(user1Choice),
        user2Choice = Rx<String?>(user2Choice);

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      chattingId: json['chattingId'],
      category: json['category'],
      user1: json['user1'],
      user2: json['user2'],
      user1Choice: json['user1Choice'],
      user2Choice: json['user2Choice'],
      createdAt: json['createdAt'],
      smallCategory: SmallCategory.fromJson(json['smallCategory']),
    );
  }
}