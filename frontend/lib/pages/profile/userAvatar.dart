// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend_matching/controllers/user_profile_controller.dart';

class UserAvatar extends StatefulWidget {
  final String img;
  final double medWidth;
  final String accessToken;
  final String deletePath;
  final String email;
  final String password;
  final bool isModifiable;

  UserAvatar(
      {required this.img,
      required this.medWidth,
      required this.accessToken,
      required this.deletePath,
      required this.email,
      required this.password,
      required this.isModifiable});

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  late UserProfileController userProfileController;

  @override
  void initState() {
    super.initState();
    userProfileController = Get.find<UserProfileController>();

    // 현재 프레임이 렌더링된 직후에 실행될 작업을 예약하는거임
    // 빌드문제 ㄹㅇ 화나네
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        userProfileController.setProfileImageUrl(widget.img);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Obx(() => userProfileController.profileImageUrl.value.isEmpty
            ? Container()
            : Opacity(
                opacity: 0.4,
                child: CircleAvatar(
                  radius: widget.medWidth / 5.2,
                  backgroundImage: NetworkImage(widget.img),
                ),
              )),
        Obx(() => userProfileController.profileImageUrl.value.isEmpty
            ? Container()
            : CircleAvatar(
                radius: widget.medWidth / 5.5,
                backgroundImage: NetworkImage(widget.img),
              )),
        if (widget.isModifiable)
          Positioned(
            right: 0,
            bottom: 0,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: () async {
                await userProfileController.deleteProfileImage(
                    widget.accessToken, widget.deletePath);
              },
            ),
          ),
        if (widget.isModifiable)
          Positioned(
            right: 120,
            bottom: 0,
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () async {
                await userProfileController
                    .uploadProfileImage(widget.accessToken);
              },
            ),
          ),
      ],
    );
  }
}
