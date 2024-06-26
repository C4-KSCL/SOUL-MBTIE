// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:io';
import 'dart:ui' as ui;

import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/signup_controller.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class SelectImagePage extends StatefulWidget {
  @override
  State<SelectImagePage> createState() => SelectImagePageState();
}

UserDataController userDataController = Get.find<UserDataController>();
final picker = ImagePicker();
List<XFile?> multiImage = [];
List<XFile?> images = [];

class SelectImagePageState extends State<SelectImagePage> {
  File? imageFile;
  CropController? cropController;

  Future<void> pickImages() async {
    final List<XFile> pickedFiles = await picker.pickMultiImage();
    for (XFile file in pickedFiles) {
      setState(() {
        imageFile = File(file.path);
        cropController = CropController(
          aspectRatio: 0.5, // 16:9 비율로 설정
          defaultCrop: Rect.fromCenter(
            center: const Offset(0.5, 0.5), // 가운데를 기준으로 크롭
            width: 0.98, // 크롭 영역의 너비 비율
            height: 0.98, // 크롭 영역의 높이 비율
          ),
        );
      });
      await showCropDialog();
    }
  }

  Future<void> showCropDialog() async {
    if (cropController == null || imageFile == null) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('이미지 크롭'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: CropImage(
            controller: cropController!,
            image: Image.file(imageFile!, fit: BoxFit.contain),
            gridColor: Colors.white70,
            paddingSize: 20,
            touchSize: 30,
            gridCornerSize: 15,
            gridThinWidth: 2,
            gridThickWidth: 5,
            scrimColor: Colors.black54,
            alwaysShowThirdLines: true,
            minimumImageSize: 300,
            maximumImageSize: double.infinity,
            alwaysMove: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              await cropAndAddImage();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Future<void> cropAndAddImage() async {
    if (imageFile == null || cropController == null) return;

    final croppedImage = await cropController!.croppedBitmap();

    final byteData =
        await croppedImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    final buffer = byteData.buffer.asUint8List();

    final directory = await getTemporaryDirectory();
    final filePath = path.join(directory.path,
        'cropped_image_${DateTime.now().millisecondsSinceEpoch}.png');
    final file = File(filePath);
    await file.writeAsBytes(buffer);

    setState(() {
      images.add(XFile(file.path));
      imageFile = null;
      cropController = null;
    });
  }

  Future<void> uploadImages(List<XFile?>? pickedFiles) async {
    final url = Uri.parse('https://soulmbti.shop:8000/signup/image');
    SignupController signupController = Get.find<SignupController>();
    String userEmail = signupController.signupArray.isNotEmpty
        ? signupController.signupArray[0]
        : '';
    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['email'] = userEmail;
      for (var pickedFile in pickedFiles!) {
        request.files.add(await http.MultipartFile.fromPath(
          'files',
          pickedFile!.path,
        ));
        print(pickedFile.path);
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Images uploaded successfully!');
        userDataController.logout();
      } else {
        print('Failed to upload images: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("추가로 이미지를 선택해주세요!")),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: IconButton(
                    onPressed: pickImages,
                    icon: const Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                itemCount: images.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1 / 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(
                              File(images[index]!.path),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 15,
                          ),
                          onPressed: () {
                            setState(() {
                              images.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 350,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7EA5F3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  if (images.isNotEmpty) {
                    if (images.length <= 3) {
                      uploadImages(images);
                      print(images);
                      userDataController.logout();
                    } else {
                      print('이미지는 최대 3개입니다.');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('이미지 초과'),
                            content: const Text('이미지는 최대 3개입니다.'),
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
                    }
                  } else {
                    print('이미지는 최소 1개 이상이어야 합니다.');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('이미지 추가'),
                          content: const Text('이미지를 1장 이상 넣어주세요.'),
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
                  }
                },
                child: const Text(
                  '다음으로',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
