import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/user.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import '../config.dart';

class UserProfileController extends GetxController {
  static String? baseUrl = AppConfig.baseUrl;

  Rx<User> userInfo = User(
    email: '',
    password: '',
    nickname: '',
    phoneNumber: '',
    age: '',
    gender: '',
    myMBTI: '',
    myKeyword: '',
    friendKeyword: '',
    userNumber: 0,
  ).obs;

  var profileImageUrl = ''.obs; // 사용자 프로필 이미지 URL을 관리하는 Observable 변수
  UserDataController userDataController = Get.find<UserDataController>();

  void setProfileImageUrl(String url) {
    profileImageUrl.value = url; // 프로필 이미지 URL 업데이트
  }

  Future<void> deleteProfileImage(String accessToken, String deletePath) async {
    final url = Uri.parse('$baseUrl/edit/deleteprofile');
    var response =
        await _postRequest(url, accessToken, {'deletepath': deletePath});

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      print("AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도");
      response = await _postRequestWithRefreshToken(url, accessToken,
          userDataController.refreshToken, {'deletepath': deletePath});

      if (response.statusCode == 300) {
        // 새로운 토큰을 받아서 갱신
        print("새로운 토큰을 받아서 갱신 및 요청");
        final newTokens = jsonDecode(response.body);
        userDataController.updateTokens(
            newTokens['accessToken'], newTokens['refreshToken']);

        // 갱신된 토큰으로 다시 요청
        response = await _postRequest(
            url, userDataController.accessToken, {'deletepath': deletePath});
      } else if (response.statusCode == 402) {
        // RefreshToken도 만료된 경우
        print('리프레시 토큰 만료, 재로그인');
        Get.snackbar('실패', '로그인이 필요합니다.');
        userDataController.logout();
        return;
      } else {
        print('오류 발생: ${response.statusCode}');
        return;
      }
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Profile image deleted successfully: $data');
      userInfo.value = User.fromJson(data['user']);
      Get.find<UserDataController>().updateUserInfo(userInfo.value);
      print('User info updated: ${userInfo.value}');
    } else {
      print('Error occurred: ${response.statusCode}');
    }
  }

  Future<void> uploadProfileImage(String accessToken) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var request = http.MultipartRequest(
          'POST', Uri.parse('$baseUrl/edit/addprofile'))
        ..headers['accesstoken'] = accessToken
        ..files
            .add(await http.MultipartFile.fromPath('files', pickedFile.path));

      var response = await request.send();

      if (response.statusCode == 401) {
        // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
        print("AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도");
        response = await _postMultipartRequestWithRefreshToken(
            Uri.parse('$baseUrl/edit/addprofile'),
            accessToken,
            userDataController.refreshToken,
            pickedFile);

        if (response.statusCode == 300) {
          // 새로운 토큰을 받아서 갱신
          print("새로운 토큰을 받아서 갱신 및 요청");
          final newTokens = jsonDecode(await response.stream.bytesToString());
          userDataController.updateTokens(
              newTokens['accessToken'], newTokens['refreshToken']);

          // 갱신된 토큰으로 다시 요청
          request = http.MultipartRequest(
              'POST', Uri.parse('$baseUrl/edit/addprofile'))
            ..headers['accesstoken'] = userDataController.accessToken
            ..files.add(
                await http.MultipartFile.fromPath('files', pickedFile.path));

          response = await request.send();
        } else if (response.statusCode == 402) {
          // RefreshToken도 만료된 경우
          print('리프레시 토큰 만료, 재로그인');
          Get.snackbar('실패', '로그인이 필요합니다.');
          userDataController.logout();
          return;
        } else {
          print('오류 발생: ${response.statusCode}');
          return;
        }
      }

      if (response.statusCode == 200) {
        final respBody = await http.Response.fromStream(response);
        final data = jsonDecode(respBody.body);
        print('Profile image uploaded successfully: $data');
        userInfo.value = User.fromJson(data['user']);
        Get.find<UserDataController>().updateUserInfo(userInfo.value);
        print('User info updated: ${userInfo.value}');
      } else {
        print('Image upload failed: ${response.statusCode}');
      }
    }
  }

  Future<http.Response> _postRequest(
      Uri url, String accessToken, Map<String, dynamic> body) async {
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'accesstoken': accessToken},
      body: jsonEncode(body),
    );
  }

  Future<http.Response> _postRequestWithRefreshToken(
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

  Future<http.StreamedResponse> _postMultipartRequestWithRefreshToken(Uri url,
      String accessToken, String refreshToken, XFile pickedFile) async {
    var request = http.MultipartRequest('POST', url)
      ..headers['accesstoken'] = accessToken
      ..headers['refreshtoken'] = refreshToken
      ..files.add(await http.MultipartFile.fromPath('files', pickedFile.path));
    return await request.send();
  }
}
