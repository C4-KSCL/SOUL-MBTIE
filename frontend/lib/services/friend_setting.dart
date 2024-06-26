import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config.dart';

class FriendSettingService {
  static Future<void> updateFriendMbtiSetting(
    String accessToken,
    String refreshToken,
    String friendMBTI,
    String friendMaxAge,
    String friendMinAge,
    String friendGender,
  ) async {
    String? baseUrl=AppConfig.baseUrl;

    final url = Uri.parse('$baseUrl/findfriend/settingMBTI');
    var response = await _postRequest(
      url,
      accessToken,
      {
        'friendMBTI': friendMBTI,
        'friendMaxAge': friendMaxAge,
        'friendMinAge': friendMinAge,
        'friendGender': friendGender,
      },
    );

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      print("AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도");
      response = await _postRequestWithRefreshToken(
        url,
        accessToken,
        refreshToken,
        {
          'friendMBTI': friendMBTI,
          'friendMaxAge': friendMaxAge,
          'friendMinAge': friendMinAge,
          'friendGender': friendGender,
        },
      );

      if (response.statusCode == 300) {
        // 새로운 토큰을 받아서 갱신 후 요청
        print("새로운 토큰을 받아서 갱신 및 요청");
        final newTokens = jsonDecode(response.body);
        UserDataController.to
            .updateTokens(newTokens['accessToken'], newTokens['refreshToken']);
        response = await _postRequest(
          url,
          newTokens['accessToken'],
          {
            'friendMBTI': friendMBTI,
            'friendMaxAge': friendMaxAge,
            'friendMinAge': friendMinAge,
            'friendGender': friendGender,
          },
        );
      } else if (response.statusCode == 402) {
        print('리프레시 토큰 만료, 재로그인');
        Get.snackbar('실패', '로그인이 필요합니다.');
        UserDataController.to.logout();
        return;
      }
    }

    if (response.statusCode == 200) {
      print('친구mbti 변경 성공');
    } else {
      print('친구mbti 변경 실패: ${response.body} ${response.statusCode}');
    }
  }

  static Future<void> updateFriendKeywordSetting(
      String accessToken, String refreshToken, String friendKeyword) async {
    late final String? baseUrl;
    baseUrl = dotenv.env['SERVER_URL'];

    final url = Uri.parse('$baseUrl/findfriend/settingKeyword');
    var response = await _postRequest(
      url,
      accessToken,
      {
        'friendKeyword': friendKeyword,
      },
    );

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      print("AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도");
      response = await _postRequestWithRefreshToken(
        url,
        accessToken,
        refreshToken,
        {
          'friendKeyword': friendKeyword,
        },
      );

      if (response.statusCode == 300) {
        // 새로운 토큰을 받아서 갱신 후 요청
        print("새로운 토큰을 받아서 갱신 및 요청");
        final newTokens = jsonDecode(response.body);
        UserDataController.to
            .updateTokens(newTokens['accessToken'], newTokens['refreshToken']);
        response = await _postRequest(
          url,
          newTokens['accessToken'],
          {
            'friendKeyword': friendKeyword,
          },
        );
      } else if (response.statusCode == 402) {
        print('리프레시 토큰 만료, 재로그인');
        Get.snackbar('실패', '로그인이 필요합니다.');
        UserDataController.to.logout();
        return;
      }
    }

    if (response.statusCode == 200) {
      print('친구키워드 변경 성공');
    } else {
      print('친구키워드 변경 실패: ${response.body} ${response.statusCode}');
    }
  }

  static Future<http.Response> _postRequest(
      Uri url, String accessToken, Map<String, dynamic> body) async {
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accesstoken': accessToken,
      },
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> _postRequestWithRefreshToken(
      Uri url,
      String accessToken,
      String refreshToken,
      Map<String, dynamic> body) async {
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accesstoken': accessToken,
        'refreshtoken': refreshToken,
      },
      body: jsonEncode(body),
    );
  }
}
