import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_matching/components/textfield.dart';
import 'package:frontend_matching/controllers/find_friend_controller.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:frontend_matching/controllers/setting_modify_controller.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/user_image.dart';
import 'package:frontend_matching/pages/matching/mbti_setting_page.dart';
import 'package:frontend_matching/pages/profile/image_modify_page.dart';
import 'package:frontend_matching/services/friend_setting.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:page_indicator/page_indicator.dart';
import '../../theme/colors.dart';
import '../../theme/text_style.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<TextEditingController> sendingControllers = [];
  final CarouselController _carouselController = CarouselController();
  final PageController pageController = PageController(initialPage: 0);

  String accessToken = '';
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
    }

    // 매칭된 사람 수만큼 컨트롤러 리스트 초기화
    int matchingFriendsCount =
        FindFriendController.to.matchingFriendInfoList.length;
    for (int i = 0; i < matchingFriendsCount; i++) {
      sendingControllers.add(TextEditingController());
    }
  }

  void navigateToImageModifyPage() {
    final containerWidth = MediaQuery.of(context).size.width;
    final containerHeight = Get.height - 360;
    final aspectRatio = containerWidth / containerHeight;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ImageModifyPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/logo.svg',
            ),
            CupertinoButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MbtiSettingPage(),
                  ),
                );
              },
              child: SvgPicture.asset(
                'assets/icons/setting.svg',
              ),
            ),
          ],
        ),
        elevation: 0.0,
        titleTextStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        backgroundColor: blueColor5,
      ),
      backgroundColor: blueColor5,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Container(
          height: Get.height,
          decoration: BoxDecoration(
            color: whiteColor1,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5.0,
                spreadRadius: 1.0,
                offset: const Offset(5, 5), // 그림자의 위치
              ),
            ],
          ),
          child: Obx(() {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                child: CarouselSlider(
                  items: List.generate(
                        FindFriendController.to.matchingFriendInfoList.length,
                        (infoIndex) {
                          if (infoIndex >= sendingControllers.length) {
                            sendingControllers.add(TextEditingController());
                          }
                          return Container(
                            width: Get.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      height: Get.height - 360,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: PageIndicatorContainer(
                                        align: IndicatorAlign.bottom,
                                        length: FindFriendController
                                                .to
                                                .matchingFriendImageList[
                                                    infoIndex]
                                                .length +
                                            1,
                                        indicatorSpace: 10.0,
                                        padding: const EdgeInsets.all(10),
                                        indicatorColor: Colors.white,
                                        indicatorSelectorColor: Colors.blue,
                                        shape: IndicatorShape.circle(size: 8),
                                        child: PageView.builder(
                                          controller: pageController,
                                          itemCount: FindFriendController
                                                  .to
                                                  .matchingFriendImageList[
                                                      infoIndex]
                                                  .length +
                                              1,
                                          itemBuilder: (context, imageIndex) {
                                            if (imageIndex <
                                                FindFriendController
                                                    .to
                                                    .matchingFriendImageList[
                                                        infoIndex]
                                                    .length) {
                                              UserImage friendImage =
                                                  FindFriendController.to
                                                          .matchingFriendImageList[
                                                      infoIndex][imageIndex];
                                              return Image.network(
                                                friendImage.imagePath,
                                                fit: BoxFit.cover,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  } else {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }
                                                },
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object error,
                                                    StackTrace? stackTrace) {
                                                  return Image.asset(
                                                    'assets/icons/defalut_user.png',
                                                    width: 50,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                    alignment: Alignment.center,
                                                  );
                                                },
                                              );
                                            } else {
                                              final analysis =
                                                  FindFriendController
                                                      .to
                                                      .matchingFriendInfoList[
                                                          infoIndex]
                                                      .analysis;
                                              final displayText =
                                                  analysis != null &&
                                                          analysis.isNotEmpty
                                                      ? analysis
                                                      : '분석 정보가 없습니다.';
                                              return Container(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text(
                                                        '분석보기',
                                                        style: TextStyle(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 30),
                                                      Text(
                                                        displayText,
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  SingleChildScrollView(
                                    child: Row(
                                      children: [
                                        Text(
                                          FindFriendController
                                              .to
                                              .matchingFriendInfoList[infoIndex]
                                              .nickname,
                                          style: blackTextStyle8,
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          width: 40,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: FindFriendController
                                                        .to
                                                        .matchingFriendInfoList[
                                                            infoIndex]
                                                        .gender ==
                                                    "남"
                                                ? blueColor1
                                                : pinkColor1,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Center(
                                            // 나이
                                            child: Text(
                                              '${FindFriendController.to.matchingFriendInfoList[infoIndex].age}세',
                                              style: whiteTextStyle2,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          FindFriendController
                                              .to
                                              .matchingFriendInfoList[infoIndex]
                                              .myMBTI!,
                                          style: blackTextStyle1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: FindFriendController
                                          .to
                                          .matchingFriendInfoList[infoIndex]
                                          .myKeyword!
                                          .split(',')
                                          .map((item) => item.trim())
                                          .map(
                                            (item) => Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: greyColor6,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  IconTextFieldBox(
                                    hintText: '간단하게 인사를 해봐요',
                                    onPressed: () async {
                                      if (sendingControllers[infoIndex]
                                          .text
                                          .isNotEmpty) {
                                        await FriendController
                                            .sendFriendRequest(
                                          oppEmail: FindFriendController
                                              .to
                                              .matchingFriendInfoList[infoIndex]
                                              .email,
                                          content: sendingControllers[infoIndex]
                                              .text,
                                        ).then((value) {
                                          // 친구 요청 보낸 알림 띄우기
                                          Get.snackbar("친구 요청 성공",
                                              "${FindFriendController.to.matchingFriendInfoList[infoIndex].nickname}에게 친구 요청을 보냈습니다.");
                                          // 요청 보낸 친구는 리스트에서 삭제
                                          FindFriendController
                                              .to.matchingFriendInfoList
                                              .removeAt(infoIndex);
                                          FindFriendController
                                              .to.matchingFriendImageList
                                              .removeAt(infoIndex);
                                        });
                                        sendingControllers[infoIndex].clear();
                                        FocusScope.of(context).unfocus();
                                        FriendController.getFriendSentRequest();
                                      }
                                    },
                                    textEditingController:
                                        sendingControllers[infoIndex],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ) +
                      [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "더 많은 친구를 만나고 싶나요?",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: blueColor1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                onPressed: () async {
                                  await FindFriendController.findFriends();
                                  _carouselController.jumpToPage(0);
                                  FocusScope.of(context).unfocus();
                                },
                                child: const Text(
                                  "친구 찾아보기",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                  options: CarouselOptions(
                    scrollDirection: Axis.vertical,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                  ),
                  carouselController: _carouselController,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in sendingControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
