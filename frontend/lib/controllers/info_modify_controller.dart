import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/user.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class InfoModifyController extends GetxController {
  static String? baseUrl = AppConfig.baseUrl;

  Rx<User> userInfo = User(
    email: '',
    password: '',
    nickname: '',
    phoneNumber: '',
    age: '',
    gender: '',
    userNumber: 0,
  ).obs;

  Future<void> InfoModify(
    String password,
    String nickname,
    String phoneNumber,
    String age,
  ) async {
    await _modifyInfo(
      'edit/info',
      {
        'password': password,
        'nickname': nickname,
        'phoneNumber': phoneNumber,
        'age': age
      },
    );
  }

  Future<void> MbtiModify(String myMBTI) async {
    await _modifyInfo('edit/infoMBTI', {'myMBTI': myMBTI});
  }

  Future<void> KeywordModify(String myKeyword) async {
    await _modifyInfo('edit/infoKeyword', {'myKeyword': myKeyword});
  }

  Future<void> _modifyInfo(String endpoint, Map<String, dynamic> body) async {
    String url = '$baseUrl/$endpoint';
    String accessToken = UserDataController.to.accessToken;
    String refreshToken = UserDataController.to.refreshToken;

    var response = await _postRequest(url, accessToken, body);

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      response = await _postRequestWithRefreshToken(
          url, accessToken, refreshToken, body);

      if (response.statusCode == 300) {
        // 새로운 토큰을 받아서 갱신
        final newTokens = jsonDecode(response.body);
        UserDataController.to
            .updateTokens(newTokens['accessToken'], newTokens['refreshToken']);

        // 갱신된 토큰으로 다시 정보 수정 요청
        response =
            await _postRequest(url, UserDataController.to.accessToken, body);

        if (response.statusCode == 200) {
          _handleSuccessResponse(response);
        } else {
          _handleErrorResponse(response);
        }
      } else if (response.statusCode == 402) {
        // RefreshToken도 만료된 경우
        print('Refresh token expired, please log in again.');
        Get.snackbar('실패', '재로그인이 필요합니다.');
        UserDataController.to.logout();
      } else {
        _handleErrorResponse(response);
      }
    } else if (response.statusCode == 200) {
      _handleSuccessResponse(response);
    } else {
      _handleErrorResponse(response);
    }
  }

  Future<http.Response> _postRequest(
      String url, String accessToken, Map<String, dynamic> body) async {
    return await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json', 'accessToken': accessToken},
      body: jsonEncode(body),
    );
  }

  Future<http.Response> _postRequestWithRefreshToken(
      String url,
      String accessToken,
      String refreshToken,
      Map<String, dynamic> body) async {
    return await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      },
      body: jsonEncode(body),
    );
  }

  void _handleSuccessResponse(http.Response response) {
    final data = jsonDecode(response.body);
    userInfo.value = User.fromJson(data['user']);
    Get.find<UserDataController>().updateUserInfo(userInfo.value);
    print('정보 수정 성공');
  }

  void _handleErrorResponse(http.Response response) {
    print('정보 수정 오류 발생: ${response.statusCode}');
  }
}
