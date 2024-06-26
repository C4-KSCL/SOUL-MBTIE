import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_matching/pages/signup/imageUpload/select_image_page.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

String? baseUrl=AppConfig.baseUrl;

class FindPassword {
  static Future<String?> findPassword(String email) async {


    final url = Uri.parse('$baseUrl/auth/findpw');
    try {
      final response = await http.post(
        url,
        body: {
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        print('비밀번호 찾기 인증 성공');
        Map<String, dynamic> data = json.decode(response.body);
        int verificationCode = data['verificationCode'];
        print(verificationCode);
        return verificationCode.toString();
      } else if (response.statusCode == 301) {
        print('존재하지 않는 이메일');
      } else if (response.statusCode == 500) {
        print('서버 에러');
      } else {
        print('알 수 없는 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
    return null;
  }

  static Future<void> setPassword(String email, String password) async {

    final url = Uri.parse('$baseUrl/auth/setpw');
    try {
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        print('비밀번호 변경 성공');
        userDataController.logout();
      } else if (response.statusCode == 304) {
        print('올바르지 않은 값을 보냄');
      } else if (response.statusCode == 500) {
        print('비밀번호 변경 실패');
      } else {
        print('알 수 없는 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }
}
