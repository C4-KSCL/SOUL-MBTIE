import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/service_center_controller.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  XFile? imageFile;
  String accessToken = '';
  String? selectedCategory;
  ServiceCenterController serviceCenterController = ServiceCenterController();

  @override
  void initState() {
    super.initState();
    final UserDataController controller = Get.find<UserDataController>();
    accessToken = controller.accessToken;
    print(accessToken);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor5,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('게시글 작성'),
        backgroundColor: blueColor5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: ['건의사항', '불편사항', '신고'].map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
                decoration: const InputDecoration(
                  labelText: '카테고리',
                ),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: '제목'),
              ),
              const SizedBox(height: 16.0),
              Container(
                height: 200.0, // 고정된 높이 설정
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: contentController,
                  maxLines: null,
                  expands: true, // TextField가 부모 Container의 크기에 맞게 확장
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '내용을 입력하세요',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text('이미지 첨부하기'),
              ),
              const SizedBox(height: 10),
              if (imageFile != null) Image.file(File(imageFile!.path)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String category = selectedCategory ?? '';
          String title = titleController.text;
          String content = contentController.text;
          print(category);
          print(title);
          print(content);
          if (category == "") {
            showDialog(
              context: Get.context!,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('카테고리'),
                  content: const Text('카테고리의 값이 비어있습니다.'),
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
          } else if (title == "") {
            showDialog(
              context: Get.context!,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('제목'),
                  content: const Text('제목이 비어있습니다.'),
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
          } else if (content == "") {
            showDialog(
              context: Get.context!,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('내용'),
                  content: const Text('내용이 비어있습니다.'),
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
          } else {
            serviceCenterController.submitPost(
                category, title, content, imageFile, accessToken);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
