import 'package:flutter/material.dart';
import 'package:frontend_matching/components/gap.dart';
import 'package:frontend_matching/components/gender_button.dart';
import 'package:frontend_matching/components/mbti_keyword.dart';
import 'package:frontend_matching/components/textfield.dart';
import 'package:frontend_matching/controllers/keyword_controller.dart';
import 'package:frontend_matching/controllers/setting_modify_controller.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/pages/matching/keyword_setting_page.dart';
import 'package:frontend_matching/services/friend_setting.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';

class MbtiSettingPage extends StatefulWidget {
  const MbtiSettingPage({super.key});

  @override
  State<MbtiSettingPage> createState() => _MbtiSettingPageState();
}

class _MbtiSettingPageState extends State<MbtiSettingPage> {
  final TextEditingController sendingController = TextEditingController();
  final TextEditingController minAgeController = TextEditingController();
  final TextEditingController maxAgeController = TextEditingController();
  final pageController = PageController();

  String accessToken = '';
  String refreshToken = '';
  String email = '';
  String nickname = '';
  String age = '';
  String gender = '';
  String mbti = '';
  String imagePath0 = '';
  String imagePath1 = '';
  String imagePath2 = '';
  int imageCount = 0;
  List<String> validImagePaths = [];
  String profileImagePath =
      'https://matchingimage.s3.ap-northeast-2.amazonaws.com/defalut_user.png';

  String selectedMBTI = '';
  int genderInt = 10;
  String genderString = '';

  late SettingModifyController settingModifyController;
  FriendSettingService settingService = FriendSettingService();

  @override
  void initState() {
    super.initState();
    settingModifyController = Get.put(SettingModifyController());
    final controller = Get.find<UserDataController>();
    if (controller.user.value != null) {
      accessToken = controller.accessToken;
      refreshToken = controller.refreshToken;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        titleTextStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        backgroundColor: blueColor5,
      ),
      backgroundColor: blueColor5,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '이상형 설정하기',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 27),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(
                      Icons.double_arrow_rounded,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KeywordSettingPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Gap(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GenderButton(
                    onGenderSelected: (selectedValue) {
                      genderInt = selectedValue;
                      if (genderInt == 1) {
                        genderString = "남";
                      } else {
                        genderString = "여";
                      }
                      print(genderString);
                    },
                  ),
                ],
              ),
              const Gap(),
              MbtiKeyWord(
                title: 'mbti',
                onMbtiSelected: (String mbti) {
                  selectedMBTI = mbti;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NumberInputField(
                    controller: minAgeController,
                    hintText: '최소 나이',
                    textType: '',
                  ),
                  const Icon(Icons.remove),
                  NumberInputField(
                    controller: maxAgeController,
                    hintText: '최대 나이',
                    textType: '',
                  ),
                ],
              ),
              const Gap(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7EA5F3),
                      minimumSize: const Size(320, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text('변경하기',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    onPressed: () async {
                      settingModifyController.addToSettingArray(selectedMBTI);
                      settingModifyController
                          .addToSettingArray(maxAgeController.text);
                      settingModifyController
                          .addToSettingArray(minAgeController.text);
                      settingModifyController.addToSettingArray(genderString);
                      print(settingModifyController);

                      if (selectedMBTI.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('mbti'),
                              content: const Text('mbti가 비어있습니다.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (maxAgeController.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('최대나이'),
                              content: const Text('최대나이가 비어있습니다.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (minAgeController.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('최소나이'),
                              content: const Text('최소나이가 비어있습니다.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (genderString.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('성별'),
                              content: const Text('성별이 비어있습니다.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        await FriendSettingService.updateFriendMbtiSetting(
                          accessToken,
                          refreshToken,
                          selectedMBTI,
                          maxAgeController.text,
                          minAgeController.text,
                          genderString,
                        );
                        KeywordController.to.resetMBTI();
                        print(selectedMBTI);
                        Get.back();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
