import 'dart:convert';

import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/post.dart';
import 'package:frontend_matching/models/post_image.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../config.dart';

class ServiceCenterController extends GetxController {
  static String? baseUrl = AppConfig.baseUrl;

  UserDataController userDataController = Get.find<UserDataController>();

  Future<Map<String, dynamic>> fetchPosts(String accessToken) async {
    final url = Uri.parse('$baseUrl/customerService/readGeneral');
    var response = await _getRequest(url, accessToken);

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      print("AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도");
      response = await _getRequestWithRefreshToken(
          url, accessToken, userDataController.refreshToken);

      if (response.statusCode == 300) {
        // 새로운 토큰을 받아서 갱신
        print("새로운 토큰을 받아서 갱신 후 요청");
        final newTokens = jsonDecode(response.body);
        userDataController.updateTokens(
            newTokens['accessToken'], newTokens['refreshToken']);

        // 갱신된 토큰으로 다시 요청
        response = await _getRequest(url, userDataController.accessToken);
      } else if (response.statusCode == 402) {
        // RefreshToken도 만료된 경우
        print('리프레시 토크ㄴ 만료, 재로그인');
        Get.snackbar('실패', '로그인이 필요합니다.');
        userDataController.logout();
        throw Exception('Failed to load posts');
      } else {
        print('오류 발생: ${response.statusCode}');
        throw Exception('Failed to load posts');
      }
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Server response: $data');

      List<Post> posts =
          (data['posts'] as List).map((post) => Post.fromJson(post)).toList();
      List<PostImage> images = (data['images'] as List)
          .map((image) => PostImage.fromJson(image))
          .toList();
      return {
        'posts': posts,
        'images': images,
      };
    } else {
      print('Server error: ${response.statusCode} ${response.reasonPhrase}');
      throw Exception('Failed to load posts');
    }
  }

  Future<void> submitPost(
    String postCategory,
    String postTitle,
    String postContent,
    XFile? imageFile,
    String accessToken,
  ) async {
    final url = Uri.parse('$baseUrl/customerService/post');
    var request = http.MultipartRequest('POST', url);

    request.headers['accesstoken'] = accessToken;

    request.fields['postCategory'] = postCategory;
    request.fields['postTitle'] = postTitle;
    request.fields['postContent'] = postContent;

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          imageFile.path,
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      print("AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도");
      response = await _postMultipartRequestWithRefreshToken(
          url,
          accessToken,
          userDataController.refreshToken,
          postCategory,
          postTitle,
          postContent,
          imageFile);

      if (response.statusCode == 300) {
        // 새로운 토큰을 받아서 갱신
        print("새로운 토큰을 받아서 갱신 후 요청");
        final newTokens = jsonDecode(await response.stream.bytesToString());
        userDataController.updateTokens(
            newTokens['accessToken'], newTokens['refreshToken']);

        // 갱신된 토큰으로 다시 요청
        request = http.MultipartRequest('POST', url)
          ..headers['accesstoken'] = userDataController.accessToken
          ..fields['postCategory'] = postCategory
          ..fields['postTitle'] = postTitle
          ..fields['postContent'] = postContent;

        if (imageFile != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'files',
              imageFile.path,
            ),
          );
        }

        response = await request.send();
      } else if (response.statusCode == 402) {
        // RefreshToken도 만료된 경우
        print('리브레시토큰 만료, 재로그인');
        Get.snackbar('실패', '로그인이 필요합니다.');
        userDataController.logout();
        return;
      } else {
        print('오류 발생: ${response.statusCode}');
        return;
      }
    }

    if (response.statusCode == 200) {
      print('게시글 작성 성공');
      Get.back();
      Get.back();
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<http.Response> _getRequest(Uri url, String accessToken) async {
    return await http.get(
      url,
      headers: {'Content-Type': 'application/json', 'accesstoken': accessToken},
    );
  }

  Future<http.Response> _getRequestWithRefreshToken(
      Uri url, String accessToken, String refreshToken) async {
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accesstoken': accessToken,
        'refreshtoken': refreshToken,
      },
    );
  }

  Future<http.StreamedResponse> _postMultipartRequestWithRefreshToken(
    Uri url,
    String accessToken,
    String refreshToken,
    String postCategory,
    String postTitle,
    String postContent,
    XFile? imageFile,
  ) async {
    var request = http.MultipartRequest('POST', url)
      ..headers['accesstoken'] = accessToken
      ..headers['refreshtoken'] = refreshToken
      ..fields['postCategory'] = postCategory
      ..fields['postTitle'] = postTitle
      ..fields['postContent'] = postContent;

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          imageFile.path,
        ),
      );
    }

    return await request.send();
  }
}
