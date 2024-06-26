// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/signup_controller.dart';
import 'package:frontend_matching/pages/signup/imageUpload/select_image_page.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ProfileImagePage extends StatefulWidget {
  const ProfileImagePage({Key? key}) : super(key: key);

  @override
  State<ProfileImagePage> createState() => _ProfileImagePageState();
}

class _ProfileImagePageState extends State<ProfileImagePage> {
  XFile? _image;
  final ImagePicker picker = ImagePicker();
  SignupController signupController = Get.find<SignupController>();

  Future<void> getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<void> uploadProfileImage(XFile pickedFile) async {
    final url = Uri.parse('https://soulmbti.shop:8000/signup/profile');
    try {
      var request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath('files', pickedFile.path))
        ..fields['email'] = signupController.signupArray[0];
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Profile image uploaded successfully!');
      } else {
        print('Failed to upload profile image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("프로필 이미지를 선택해주세요!"),
        backgroundColor: blueColor5,
      ),
      backgroundColor: blueColor5,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 6),
                shape: BoxShape.circle,
                color: Color(0xFF7EA5F3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(150),
                          child: Image.file(
                            File(_image!.path),
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                          ),
                        )
                      : Center(
                          child: IconButton(
                            onPressed: () {
                              getImage(ImageSource.gallery);
                            },
                            icon: Icon(Icons.add_a_photo, size: 60),
                            color: Colors.white,
                          ),
                        ),
                  Positioned(
                    bottom: 15,
                    right: 15,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: greyColor3,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _image = null;
                          });
                        },
                        icon: Icon(Icons.delete),
                        color: greyColor5,
                        iconSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 200),
            SizedBox(
              width: 350,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_image != null) {
                    uploadProfileImage(_image!);
                  } else {
                    print('Please select a profile image.');
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectImagePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7EA5F3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text(
                  '다음으로',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
