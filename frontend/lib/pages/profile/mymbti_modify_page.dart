import 'package:flutter/material.dart';
import 'package:frontend_matching/components/gap.dart';
import 'package:frontend_matching/components/mbti_keyword.dart';
import 'package:frontend_matching/controllers/info_modify_controller.dart';
import 'package:frontend_matching/controllers/keyword_controller.dart';
import 'package:frontend_matching/controllers/setting_modify_controller.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/services/friend_setting.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';

class MyMbtiModifyPage extends StatefulWidget {
  const MyMbtiModifyPage({super.key});

  @override
  State<MyMbtiModifyPage> createState() => _MyMbtiModifyPageState();
}

class _MyMbtiModifyPageState extends State<MyMbtiModifyPage> {
  final TextEditingController sendingController = TextEditingController();
  final TextEditingController minAgeController = TextEditingController();
  final TextEditingController maxAgeController = TextEditingController();
  final pageController = PageController();

  String accessToken = '';

  String selectedMBTI = '';
  bool isMbtiComplete = false; // 버튼 활성화 관련
  //String genderString = '';

  late SettingModifyController settingModifyController;
  final infocontroller = Get.find<InfoModifyController>();
  FriendSettingService settingService = FriendSettingService();

  @override
  void initState() {
    super.initState();
    settingModifyController = Get.put(SettingModifyController());
    final controller = Get.find<UserDataController>();
    if (controller.user.value != null) {
      accessToken = controller.accessToken;
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
        backgroundColor: Colors.white,
      ),
      backgroundColor: blueColor5,
      body: SingleChildScrollView(
        child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Gap(),
            const Row(
              children: [
                Text(
                  '    이상형 설정하기',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 27),
                ),
                SizedBox(width: 100),
              ],
            ),
            const Gap(),
            const Gap(),
            MbtiKeyWord(
              title: 'mbti',
              onMbtiSelected: (String mbti) {
                setState(() {
                  selectedMBTI = mbti;
                  if (selectedMBTI.length == 4) {
                    isMbtiComplete = true;
                  } else {
                    isMbtiComplete = false;
                  }
                });
              },
            ),
            const Gap(),
            const Gap(),
            const Gap(),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7EA5F3),
                    minimumSize: const Size(300, 50),
                  ),
                  onPressed: isMbtiComplete
                      ? () async {
                          await infocontroller.MbtiModify(selectedMBTI);
                          KeywordController.to.resetMBTI();
                          print(selectedMBTI);
                          Get.back();
                        }
                      : null,
                  child: const Text('변경',
                      style: TextStyle(
                        color: Colors.white,
                      ))),
            ),
          ]),
        ),
      ),
    );
  }
}
