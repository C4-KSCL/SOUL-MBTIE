// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_unnecessary_containers, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/pages/matching/loading_page.dart';
import 'package:frontend_matching/pages/profile/buttons/Info_modify_button.dart';
import 'package:frontend_matching/pages/profile/buttons/column_button.dart';
import 'package:frontend_matching/pages/profile/image_modify_page.dart';
import 'package:frontend_matching/pages/profile/info_modiify_page.dart';
import 'package:frontend_matching/pages/profile/service_center/service_center_page.dart';
import 'package:frontend_matching/pages/profile/userAvatar.dart';
import 'package:frontend_matching/pages/signup/imageUpload/image_test.dart';
import 'package:frontend_matching/pages/signup/imageUpload/select_image_page.dart';
import 'package:frontend_matching/services/delete_user_service.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/text_style.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double medWidth = MediaQuery.of(context).size.width;
    final double medHeight = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    String my_email = '';
    String my_password = '';
    String my_nickname = '';
    String my_age = '';
    String my_gender = '';
    String my_mbti = '';
    String my_profileImagePath = '';
    String my_keyword = '';
    String accesstoken = '';

    return Scaffold(

        appBar: AppBar(
          scrolledUnderElevation:0,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("마이페이지"),
            ],
          ),
          backgroundColor: blueColor5,
        ),
        backgroundColor: blueColor5,
        body: SingleChildScrollView(
            child: GetBuilder<UserDataController>(builder: (controller) {
          if (controller.user.value != null) {
            accesstoken = controller.accessToken;
            my_email = controller.user.value!.email;
            my_password = controller.user.value!.password;
            my_nickname = controller.user.value!.nickname;
            my_age = controller.user.value!.age;
            my_gender = controller.user.value!.gender;
            my_mbti = controller.user.value!.myMBTI!;
            my_keyword = controller.user.value!.myKeyword!;
            if (my_gender == '남') {
              my_gender = '남';
            } else {
              my_gender = '여';
            }
            my_profileImagePath = controller.user.value!.userImage!;
            print(my_profileImagePath);
          }

          return Stack(children: [
            Positioned(
                top: medHeight / 4.1,
                child: Container(
                    height: medHeight,
                    decoration: const BoxDecoration(
                        color: Color(0xFFFCFCFF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                    padding: EdgeInsets.fromLTRB(0, medHeight, medWidth, 0.0))),
            // Opacity(
            //   opacity: 0.8,
            //   child: Container(
            //     decoration: const BoxDecoration(
            //         color: Colors.white,
            //         border: Border(
            //             bottom: BorderSide(width: 0.5, color: Colors.grey))),
            //     height: statusBarHeight + 55,
            //   ),
            // ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: medHeight / 10,
                  ),
                  UserAvatar(
                    img: my_profileImagePath,
                    medWidth: medWidth,
                    accessToken: accesstoken,
                    deletePath: my_profileImagePath,
                    email: my_email,
                    password: my_password,
                    isModifiable: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        my_nickname,
                        style: TextStyle(
                            fontSize: 29, fontWeight: FontWeight.w600),
                      ),

                      // OutlinedButton(
                      //   style: OutlinedButton.styleFrom(
                      //       side: const BorderSide(
                      //           color: Colors.black26, width: 1),
                      //       backgroundColor: Colors.white,
                      //       shape: const RoundedRectangleBorder(
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(12)))),
                      //   onPressed: () {},
                      //   child: Text(
                      //     my_gender,
                      //     style: TextStyle(
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.w600,
                      //         color: blueColor3),
                      //   ),
                      // )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(medWidth / 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                //MBTI
                                my_mbti,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                //이메일
                                my_email,
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey),
                              ),
                            ),
                            Text(
                              //성별
                              my_gender,
                              style:
                                  TextStyle(fontSize: 14.0, color: Colors.grey),
                            ),
                            SizedBox(width: 10),
                            Text(
                              //나이
                              my_age + '살',
                              style:
                                  TextStyle(fontSize: 14.0, color: Colors.grey),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ...my_keyword
                                    .split(',')
                                    .map((item) => item.trim())
                                    .map(
                                      (item) => Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: greyColor6,
                                          ),
                                          padding: const EdgeInsets.all(5),
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InfoModifyButton(
                                medHeight: medHeight,
                                medWidth: medWidth,
                                pressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InfoModifyPage(),
                                    ),
                                  );
                                },
                                img: 'assets/icons/profile_modify.svg',
                                str: '내 정보 수정하기'),
                            InfoModifyButton(
                                medHeight: medHeight,
                                medWidth: medWidth,
                                pressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageModifyPage(),
                                    ),
                                  );
                                },
                                img: 'assets/icons/image.svg',
                                str: '내 사진 수정하기'),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(medWidth / 55),
                          child: const Opacity(
                              opacity: 0.6,
                              child: Divider(
                                  color: Colors.blueGrey, thickness: 0.5)),
                        ),
                        ColumnButton(
                            pressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ServiceCenterPage(),
                                ),
                              );
                            },
                            img: 'assets/icons/service_center.svg',
                            str: '고객센터'),
                        TextButton(
                            onPressed: () {
                              userDataController.logout();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.grey, width: 0.1),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/logout.svg',
                                    color: greyColor4,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '로그아웃',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )),
                        ColumnButton(
                            pressed: () {
                              DeleteUserService.deleteUser(
                                  accesstoken); //유저 탈퇴하기
                            },
                            img: 'assets/icons/trash_bin.svg',
                            str: '탈퇴하기'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]);
        })));
  }
}
