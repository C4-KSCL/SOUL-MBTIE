import 'package:flutter/material.dart';
import 'package:frontend_matching/services/nickname_check.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final RxList<String> signupArray = <String>[].obs;

  void addToSignupArray(String value) {
    signupArray.add(value);
  }

  void deleteToSignupArray() {
    if (signupArray.isNotEmpty) {
      signupArray.removeLast();
    }
  }

  void clearSignupArray() {
    signupArray.clear();
  }

  //여기부터 버튼 활성화 관련
  var isNicknameValid = false.obs;
  var isElevationButtonEnabled = false.obs;
  RxString password = ''.obs; // 닉네임은 버튼으로 자동검사
  RxString phoneNumber = ''.obs;
  RxString age = ''.obs;
  RxString gender = ''.obs;

  var friendButtonEnabled = false.obs;
  RxString maxage = ''.obs;
  RxString minage = ''.obs;
  RxString friendgender = ''.obs;

  @override
  void onInit() {
    super.onInit();
    everAll([password, phoneNumber, age, gender, isNicknameValid],
        (_) => updateButtonState());

    everAll([maxage, minage, friendgender], (_) => friendButtonState);
  }

  @override
  void onClose() {
    super.onClose();
    resetAllInputs();
  }

  void checkNickname(String nickname, BuildContext context) async {
    bool? result = await NickNameCheck.checknickname(nickname, context);
    isNicknameValid.value = result!;
    updateButtonState();
  }

  void updateButtonState() {
    bool areAllInputsFilled = password.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        age.isNotEmpty &&
        gender.isNotEmpty;
    isElevationButtonEnabled.value =
        areAllInputsFilled && isNicknameValid.value;

    print('혹시 전부값들어가잇니? : $areAllInputsFilled, 닉네임은? : $isNicknameValid');
    print('버튼 활성화 : $isElevationButtonEnabled');
  }

  void setGender(String value) {
    gender.value = value;
    updateButtonState(); // 성별이 설정될 때마다 버튼 상태 업데이트
  }

  void friendButtonState() {
    bool friendInputsFilled =
        maxage.isNotEmpty && minage.isNotEmpty && friendgender.isNotEmpty;
    friendButtonEnabled.value = friendInputsFilled;
    print('친구버튼 활성화 : $friendInputsFilled');
  }

  void friendGender(String value) {
    friendgender.value = value;
    friendButtonState();
  }

  void resetAllInputs() {
    signupArray.clear();
    isNicknameValid.value = false;
    isElevationButtonEnabled.value = false;
    password.value = '';
    phoneNumber.value = '';
    age.value = '';
    gender.value = '';
    maxage.value = '';
    minage.value = '';
    friendButtonEnabled.value = false;
    print('모든 입력 상태가 초기화되었습니다.');
  }
}
