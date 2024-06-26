import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend_matching/controllers/bottom_nav_controller.dart';
import 'package:frontend_matching/controllers/fcm_controller.dart';
import 'package:frontend_matching/controllers/find_friend_controller.dart';
import 'package:frontend_matching/controllers/keyword_controller.dart';
import 'package:frontend_matching/pages/init_page.dart';
import 'package:frontend_matching/pages/login/login_page.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config.dart';
import 'controllers/bottom_nav_controller.dart';
import 'controllers/find_friend_controller.dart';
import 'controllers/keyword_controller.dart';
import 'controllers/user_data_controller.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Android : 백그라운드일때, FCM을 받았을 때 실행
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print("백그라운드 때 받은 FCM 내용: ${message.data} ${message.sentTime}");
}

// main 함수
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //.env 파일 불러오기
  await dotenv.load(fileName: ".env");
  AppConfig.load();

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FcmController fcmController = Get.put(FcmController());
  await fcmController.initializeFcm();

  // FCM : 종료 상태/백그라운드 알림 받을 때 실행
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // 한국 시간 설정
  await initializeDateFormatting('ko_KR', null);

  AppConfig.putGetxControllerDependency();

  // 자동 로그인 여부 확인하기
  String? isAutoLogin = await AppConfig.storage.read(key: "isAutoLogin");

  // 자동 로그인이 설정된 경우
  if (isAutoLogin == "true") {
    print("자동 로그인 한적 있음");
    String? email = await AppConfig.storage.read(key: "autoLoginEmail");
    String? password = await AppConfig.storage.read(key: "autoLoginPw");
    if (email != null && password != null) {
      await UserDataController.to.loginUser(email, password);
      // 로그인 후의 UI 업데이트나 다른 처리
    }
  }

  // 상태 표시줄 색상 설정
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white, // 원하는 색상으로 변경
    statusBarIconBrightness:
        Brightness.dark,
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Obx(() => UserDataController.to.user.value == null
              ? const LoginPage()
              : const InitPage())),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        popupMenuTheme: PopupMenuThemeData(
          color: greyColor3.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
        ),
      ),
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
      ],
    );
  }
}
