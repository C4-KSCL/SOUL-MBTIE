import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_matching/controllers/user_data_controller.dart';

import '../config.dart';

class DeleteUserService {
  static Future<void> deleteUser(String accesstoken) async {
    String? baseUrl=AppConfig.baseUrl;
    try {
      var response = await http.delete(
        Uri.parse('$baseUrl/delete/user'),
        headers: {
          'accesstoken': accesstoken,
        },
      );

      if (response.statusCode == 200) {
        print('정상적으로 삭제됨');
        Get.snackbar('성공', '회원이 정상적으로 삭제됐습니다.');
        UserDataController.to.logout();
      } else if (response.statusCode == 401) {
        // 액세스 토큰이 만료된 경우, 리프레시 토큰을 사용하여 재시도
        print('Access token expired, trying with refresh token...');
        response = await http.delete(
          Uri.parse('$baseUrl/delete/user'),
          headers: {
            'accesstoken': UserDataController.to.accessToken,
            'refreshtoken': UserDataController.to.refreshToken,
          },
        );

        if (response.statusCode == 300) {
          // 새로운 토큰을 받아서 갱신
          final newTokens = jsonDecode(response.body);
          UserDataController.to.updateTokens(
              newTokens['accessToken'], newTokens['refreshToken']);

          // 갱신된 토큰으로 다시 삭제 요청
          response = await http.delete(
            Uri.parse('$baseUrl/delete/user'),
            headers: {
              'accesstoken': UserDataController.to.accessToken,
            },
          );

          if (response.statusCode == 200) {
            print('정상적으로 삭제됨');
            Get.snackbar('성공', '회원이 정상적으로 삭제됐습니다.');
            UserDataController.to.logout();
          } else {
            print('실패 : Status code: ${response.statusCode}');
          }
        } else if (response.statusCode == 402) {
          // 리프레시 토큰도 만료된 경우
          print('Refresh token expired, please log in again.');
          Get.snackbar('실패', '로그인이 필요합니다.');
          UserDataController.to.logout();
        } else {
          print('실패 : Status code: ${response.statusCode}');
        }
      } else if (response.statusCode == 411) {
        // accessToken 오류
        print('AccessToken 오류: Status code: ${response.statusCode}');
        Get.snackbar('오류', 'AccessToken이 잘못되었습니다.');
      } else if (response.statusCode == 412) {
        // refreshToken 오류
        print('RefreshToken 오류: Status code: ${response.statusCode}');
        Get.snackbar('오류', 'RefreshToken이 잘못되었습니다.');
      } else {
        print('실패 : Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('오류발생 : $e');
    }
  }
}
