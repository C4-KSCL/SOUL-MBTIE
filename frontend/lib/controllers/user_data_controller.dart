import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/bottom_nav_controller.dart';
import 'package:frontend_matching/controllers/chatting_list_controller.dart';
import 'package:frontend_matching/controllers/find_friend_controller.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:frontend_matching/controllers/signup_controller.dart';
import 'package:frontend_matching/pages/login/login_page.dart';
import 'package:frontend_matching/pages/matching/loading_page.dart';
import 'package:frontend_matching/services/fcm_token_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../pages/init_page.dart';
import '../models/user.dart';
import '../models/user_image.dart';

class UserDataController extends GetxController {
  static UserDataController get to => Get.find<UserDataController>();
  SignupController signupController = Get.find<SignupController>();
  Rxn<User?> user = Rxn<User?>(null);
  RxList<UserImage> images = <UserImage>[].obs;

  // Rx<String> matchingUserNumbers = "1,2,3".obs; // 매칭 유저 정보

  var accessToken = '';
  var refreshToken = '';

  static const signup = 'signup';
  static const register = 'register';
  static const auth = 'auth';
  static const login = 'login';

  static String? baseUrl = AppConfig.baseUrl;

  void updateTokens(String newAccessToken, String newRefreshToken) {
    // 토큰 갱신 시 사용함
    accessToken = newAccessToken;
    refreshToken = newRefreshToken;
  }

  void updateUserInfo(User newUser) {
    print('Updating user info with: $newUser');
    user.value = newUser;
    update();
  }

  void updateImageInfo(List<UserImage> newImages) {
    images.assignAll(newImages);
  }

  void resetData(){
    user.value = null;
    accessToken = '';
    refreshToken = '';
    images.value = <UserImage>[].obs;
  }

  Future<void> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/$auth/$login');

    Map<String, String> headers = {"Content-type": "application/json"};
    final body = jsonEncode({"email": email, "password": password});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // 자동 로그인 관련 아이디 비번 저장
      await AppConfig.storage.write(key: "autoLoginEmail", value: email);
      await AppConfig.storage.write(key: "autoLoginPw", value: password);
      await AppConfig.storage.write(key: "isAutoLogin", value: "true");

      FcmService.requestPermission();

      final loginUserData = jsonDecode(response.body);
      print(loginUserData);

      UserDataController.to.user.value = User.fromJson(loginUserData['user']);

      List<UserImage> images = (loginUserData['images'] as List)
          .map((data) => UserImage.fromJson(data as Map<String, dynamic>))
          .toList();

      UserDataController.to.updateImageInfo(images);

      UserDataController.to.accessToken = loginUserData['accessToken'];
      UserDataController.to.refreshToken = loginUserData['refreshToken'];
      print('login success');
      print(loginUserData['accessToken']);
      print(loginUserData['refreshToken']);

      // 필요한 데이터 가져오기
      await FriendController.getFriendList();
      await FriendController.getFriendReceivedRequest();
      await FriendController.getFriendSentRequest();
      await ChattingListController.getLastChatList();
    } else {
      print('login fail');
    }
  }

  /// 로그아웃
  void logout() async {
    await FcmService.deleteUserFcmToken(); //fcm 토큰 삭제
    await AppConfig.storage.write(key: "autoLoginEmail", value: '');
    await AppConfig.storage.write(key: "autoLoginPw", value: '');
    await AppConfig.storage
        .write(key: "isAutoLogin", value: "false"); // 자동 로그인 해제

    signupController.resetAllInputs();
    FriendController.to.resetData();
    ChattingListController.to.resetData();
    FindFriendController.to.resetData();
    resetData();
    BottomNavigationBarController.to.selectedIndex.value=0;
    Get.off(const LoginPage());
    print("로그아웃");
  }

  /// http 종류에 맞는 메소드를 이용하여 요청
  static Future<http.Response> sendHttpRequest({
    required String method,
    required Uri url,
    required String accessToken,
    String? refreshToken,
    String? body,
  }) async {
    var headers = {
      "Content-type": "application/json",
      "accessToken": accessToken,
    };
    if (refreshToken != null) {
      headers["refreshToken"] = refreshToken;
    }

    switch (method) {
      case 'get':
        return await http.get(url, headers: headers);
      case 'post':
        return await http.post(url, headers: headers, body: body);
      case 'patch':
        return await http.patch(url, headers: headers, body: body);
      case 'delete':
        return await http.delete(url, headers: headers);
      default:
        throw 'Unsupported HTTP method $method';
    }
  }

  /// http 요청 보낼때 JWT 토큰 관련 체크 과정
  static Future<http.Response> sendHttpRequestWithTokenManagement({
    required String method,
    required Uri url,
    String? body,
  }) async {
    var response = await sendHttpRequest(
      method: method,
      url: url,
      accessToken: UserDataController.to.accessToken,
      body: body,
    );

    if (response.statusCode == 401) {
      print("401 RefreshToken을 사용하여 AccessToken 갱신 시도");
      print(response.body);

      response = await sendHttpRequest(
        method: method,
        url: url,
        accessToken: UserDataController.to.accessToken,
        refreshToken: UserDataController.to.refreshToken,
        body: body,
      );

      if (response.statusCode == 300) {
        print("새로운 토큰을 받아서 갱신 및 요청");
        print(response.body);

        final newTokens = jsonDecode(response.body);
        UserDataController.to
            .updateTokens(newTokens['accessToken'], newTokens['refreshToken']);

        response = await sendHttpRequest(
          method: method,
          url: url,
          accessToken: newTokens['accessToken'],
          body: body,
        );
      } else if (response.statusCode == 402) {
        print('리프레시 토큰 만료, 재로그인');
        print(response.body);
        Get.snackbar('실패', '로그인이 필요합니다.');
        UserDataController.to.logout();
        return http.Response(
            'Unauthorized - Session expired', 402); // 로그아웃 상황이라 오류 응답 반환
      }
    }
    return response; // 갱신 성공 또는 기존 토큰 유효시 response 반환
  }
}
