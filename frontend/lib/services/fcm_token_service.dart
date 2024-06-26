import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_matching/config.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/user.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FcmService{
  static String? baseUrl=AppConfig.baseUrl;

  // 알림 설정 관련 권한 물어보기
  static void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    String? fcmToken = await messaging.getToken();
    await initUserFcmTokenTable();
    await uploadUserFcmToken(fcmToken: fcmToken.toString());
  }
  
  // 유저의 디바이스 Token 정보를 담을 테이블을 만드는 함수
  static Future<void> initUserFcmTokenTable() async {
    final url=Uri.parse("$baseUrl/alarms/init-user-token");

    var response= await UserDataController.sendHttpRequestWithTokenManagement(method: 'post', url: url,);

    if(response.statusCode==201){
      print("테이블 생성");
    }
  }

  // 유저의 디바이스 Token 정보를 저장
  static Future<void> uploadUserFcmToken({required String fcmToken}) async{
    final url=Uri.parse("$baseUrl/alarms/upload-fcm-token");

    final body=jsonEncode({'fcmToken':fcmToken});

    var response= await UserDataController.sendHttpRequestWithTokenManagement(method: 'patch', url: url,body: body,);

    print(response.statusCode);
    print(response.body);
    if(response.statusCode==200){
      AppConfig.storage.write(key:"tokenValue", value: fcmToken);
      print("$fcmToken 등록 완료");
    }
  }

  // 유저의 디바이스 Token 정보를 삭제
  static Future<void> deleteUserFcmToken() async{
    final url=Uri.parse("$baseUrl/alarms/delete-fcm-token");

    var response= await UserDataController.sendHttpRequestWithTokenManagement(method: 'patch', url: url,);
    if(response.statusCode==200){
      print("fcm 토큰 삭제 완료");
    }
  }
}