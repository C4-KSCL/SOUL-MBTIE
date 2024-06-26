import 'package:get/get.dart';

class SettingModifyController extends GetxController {
  final RxList<String> settingArray = <String>[].obs;

  void addToSettingArray(String value) {
    settingArray.add(value);
  }

  void clearSettingArray() {
    settingArray.clear();
  }
}
