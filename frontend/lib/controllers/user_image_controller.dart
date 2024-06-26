import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/user_image.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

import '../config.dart';

class UserImageController extends GetxController {
  static String? baseUrl = AppConfig.baseUrl;

  UserDataController userDataController = Get.find<UserDataController>();

  // 이미지 삭제
  Future<void> deleteImage(int index) async {
    final img = userDataController.images[index];
    final url = Uri.parse('$baseUrl/edit/deleteimage');
    String accessToken = userDataController.accessToken;
    String refreshToken = userDataController.refreshToken;

    var response =
        await _postRequest(url, accessToken, {'deletepath': img.imagePath});

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      response = await _postRequestWithRefreshToken(
          url, accessToken, refreshToken, {'deletepath': img.imagePath});

      if (response.statusCode == 300) {
        // 새로운 토큰을 받아서 갱신
        final newTokens = jsonDecode(response.body);
        userDataController.updateTokens(
            newTokens['accessToken'], newTokens['refreshToken']);

        // 갱신된 토큰으로 다시 요청
        response = await _postRequest(
            url, userDataController.accessToken, {'deletepath': img.imagePath});

        if (response.statusCode == 200) {
          _handleDeleteSuccess(response);
        } else {
          _handleErrorResponse(response, '삭제 실패');
        }
      } else if (response.statusCode == 402) {
        // RefreshToken도 만료된 경우
        print('Refresh token expired, please log in again.');
        Get.snackbar('실패', '로그인이 필요합니다.');
        userDataController.logout();
      } else {
        _handleErrorResponse(response, '삭제 실패');
      }
    } else if (response.statusCode == 200) {
      _handleDeleteSuccess(response);
    } else {
      _handleErrorResponse(response, '삭제 실패');
    }
  }

  // 이미지 추가
  Future<void> addImage(XFile pickedFile) async {
    final url = Uri.parse('$baseUrl/edit/addimage');
    String accessToken = userDataController.accessToken;
    String refreshToken = userDataController.refreshToken;

    var response = await _multipartRequest(url, accessToken, pickedFile);

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      response = await _multipartRequestWithRefreshToken(
          url, accessToken, refreshToken, pickedFile);

      if (response.statusCode == 300) {
        // 새로운 토큰을 받아서 갱신
        final newTokens = jsonDecode(await response.stream.bytesToString());
        userDataController.updateTokens(
            newTokens['accessToken'], newTokens['refreshToken']);

        // 갱신된 토큰으로 다시 요청
        response = await _multipartRequest(
            url, userDataController.accessToken, pickedFile);

        if (response.statusCode == 200) {
          _handleAddImageSuccess(response);
        } else {
          _handleErrorResponse(response, '이미지 추가 실패');
        }
      } else if (response.statusCode == 402) {
        // RefreshToken도 만료된 경우
        print('Refresh token expired, please log in again.');
        Get.snackbar('실패', '로그인이 필요합니다.');
        userDataController.logout();
      } else {
        _handleErrorResponse(response, '이미지 추가 실패');
      }
    } else if (response.statusCode == 200) {
      _handleAddImageSuccess(response);
    } else {
      _handleErrorResponse(response, '이미지 추가 실패');
    }
  }

  Future<http.Response> _postRequest(
      Uri url, String accessToken, Map<String, dynamic> body) async {
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'accessToken': accessToken},
      body: jsonEncode(body),
    );
  }

  Future<http.StreamedResponse> _multipartRequest(
      Uri url, String accessToken, XFile pickedFile) async {
    var request = http.MultipartRequest('POST', url);
    request.headers['accesstoken'] = accessToken;
    request.files
        .add(await http.MultipartFile.fromPath('files', pickedFile.path));
    return await request.send();
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
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      },
      body: jsonEncode(body),
    );
  }

  Future<http.StreamedResponse> _multipartRequestWithRefreshToken(Uri url,
      String accessToken, String refreshToken, XFile pickedFile) async {
    var request = http.MultipartRequest('POST', url);
    request.headers['accesstoken'] = accessToken;
    request.headers['refreshtoken'] = refreshToken;
    request.files
        .add(await http.MultipartFile.fromPath('files', pickedFile.path));
    return await request.send();
  }

  void _handleDeleteSuccess(http.Response response) {
    List<UserImage> newImages = (jsonDecode(response.body)['images'] as List)
        .map((data) => UserImage.fromJson(data))
        .toList();
    userDataController.images.value = newImages;
    Get.snackbar('삭제 성공', '이미지가 성공적으로 삭제되었습니다.');
  }

  void _handleAddImageSuccess(http.StreamedResponse response) async {
    String responseBody = await response.stream.bytesToString();
    List<UserImage> newImages = (jsonDecode(responseBody)['images'] as List)
        .map((data) => UserImage.fromJson(data))
        .toList();
    userDataController.images.value = newImages;
    Get.snackbar('성공', '이미지가 성공적으로 추가되었습니다.');
  }

  void _handleErrorResponse(http.BaseResponse response, String errorMessage) {
    print('$errorMessage: ${response.statusCode}');
    Get.snackbar('실패', '$errorMessage에 실패했습니다.');
  }
}
