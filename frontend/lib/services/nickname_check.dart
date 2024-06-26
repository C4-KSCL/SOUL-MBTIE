// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class NickNameCheck {
  static Future<bool?> checknickname(
      String nickname, BuildContext context) async {
    String? baseUrl=AppConfig.baseUrl;

    final url = Uri.parse('$baseUrl/signup/checknickname');
    try {
      final response = await http.post(
        url,
        body: {'nickname': nickname},
      );

      if (response.statusCode == 200) {
        print('사용 가능한 닉네임입니다.');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('닉네임 인증'),
              content: Text('사용 가능한 닉네임 입니다.'),
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
        return true; // 버튼 상태 on
      } else if (response.statusCode == 301) {
        print('이미 사용 중인 닉네임입니다.');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('닉네임 인증'),
              content: Text('이미 사용 중인 닉네임입니다.'),
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
        return false; // 버튼 상태 off
      } else {
        print('서버 에러가 발생했습니다. 에러 코드: ${response.statusCode}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('닉네임 인증'),
              content: Text('서버 에러 발생, 관리자에게 문의하세요.'),
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
        return false;
      }
    } catch (e) {
      print('닉네임 확인 중 에러가 발생했습니다: $e');
      return false;
    }
  }
}
