import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crop_image/crop_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:ui' as ui;

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final ImagePicker picker = ImagePicker();
  File? imageFile;
  List<File> croppedFiles = [];
  late final CropController controller;

  @override
  void initState() {
    super.initState();
    controller = CropController(
      aspectRatio: 0.5, // 가로:세로 비율을 1:2로 설정
      defaultCrop: Rect.fromCenter(
        center: const Offset(0.5, 0.5),
        width: 0.5,
        height: 1.0,
      ),
    );
  }

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> cropImage() async {
    if (imageFile == null) return;

    final croppedImage = await controller.croppedBitmap();

    // 크롭된 이미지를 ui.Image로 변환
    final byteData =
        await croppedImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    // ByteData를 Uint8List로 변환
    final buffer = byteData.buffer.asUint8List();

    // 크롭된 이미지를 파일로 저장
    final directory = await getTemporaryDirectory();
    final filePath = path.join(directory.path,
        'cropped_image_${DateTime.now().millisecondsSinceEpoch}.png');
    final file = File(filePath);
    await file.writeAsBytes(buffer);

    setState(() {
      croppedFiles.add(file);
      imageFile = null; // 크롭 후 원본 이미지를 초기화
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('이미지 크롭 테스트'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imageFile == null && croppedFiles.isEmpty)
                const Text('이미지를 선택하세요.')
              else if (imageFile != null)
                Expanded(
                  child: CropImage(
                    controller: controller,
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
                )
              else if (croppedFiles.isNotEmpty)
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: croppedFiles.length,
                    itemBuilder: (context, index) {
                      return Image.file(croppedFiles[index]);
                    },
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: pickImage,
              child: const Icon(Icons.add_a_photo),
            ),
            const SizedBox(width: 10),
            if (imageFile != null)
              FloatingActionButton(
                onPressed: cropImage,
                child: const Icon(Icons.crop),
              ),
          ],
        ),
      );
}
