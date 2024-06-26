import 'package:hive/hive.dart';

part 'oppuser_number.g.dart';

@HiveType(typeId: 0)
class OppUserNumber extends HiveObject{
  @HiveField(0)
  String? oppUserNumber;
}