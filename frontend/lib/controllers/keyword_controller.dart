import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend_matching/theme/colors.dart';

class KeywordController extends GetxController {
  static KeywordController get to => Get.find();

  RxList<bool> selectedIE = <bool>[false, false].obs;
  RxList<bool> selectedNS = <bool>[false, false].obs;
  RxList<bool> selectedFT = <bool>[false, false].obs;
  RxList<bool> selectedPJ = <bool>[false, false].obs;

  KeywordController() {
    resetMBTI();
  }

  String get mbti =>
      (selectedIE[0] ? 'I' : 'E') +
      (selectedNS[0] ? 'N' : 'S') +
      (selectedFT[0] ? 'F' : 'T') +
      (selectedPJ[0] ? 'P' : 'J');

  RxString selectedMBTI = ''.obs; //mbti 합치깅

  void selectMBTI(int index, String dimension) {
    switch (dimension) {
      case 'IE':
        for (int i = 0; i < selectedIE.length; i++) {
          selectedIE[i] = i == index;
        }
        break;
      case 'NS':
        for (int i = 0; i < selectedNS.length; i++) {
          selectedNS[i] = i == index;
        }
        break;
      case 'FT':
        for (int i = 0; i < selectedFT.length; i++) {
          selectedFT[i] = i == index;
        }
        break;
      case 'PJ':
        for (int i = 0; i < selectedPJ.length; i++) {
          selectedPJ[i] = i == index;
        }
        break;
    }
    updateSelectedMBTI();
  }

  void updateSelectedMBTI() {
    selectedMBTI.value = (selectedIE[0] ? 'I' : 'E') +
        (selectedNS[0] ? 'N' : 'S') +
        (selectedFT[0] ? 'F' : 'T') +
        (selectedPJ[0] ? 'P' : 'J');
  }

  void resetMBTI() {
    selectedIE.value = [false, false];
    selectedNS.value = [false, false];
    selectedFT.value = [false, false];
    selectedPJ.value = [false, false];
    update();
  }
}
