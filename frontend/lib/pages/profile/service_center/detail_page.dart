import 'package:flutter/material.dart';
import 'package:frontend_matching/components/gap.dart';
import 'package:frontend_matching/models/post.dart';
import 'package:frontend_matching/models/post_image.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';

class DetailPage extends StatefulWidget {
  final Post post;
  final PostImage? postImage;

  DetailPage({
    super.key,
    required this.post,
    required this.postImage,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('고객센터'),
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
      backgroundColor: blueColor5,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.post.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  widget.post.isAnswered == 0 ? '답변대기중' : '답변완료',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        widget.post.isAnswered == 0 ? Colors.red : Colors.blue,
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.black,
              thickness: 1.5,
            ),
            const SizedBox(height: 16.0),
            if (widget.postImage != null) ...[
              Center(
                child: Image.network(widget.postImage!.imagePath!),
              ),
              const SizedBox(height: 16.0),
            ],
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                minHeight: 200,
                maxHeight: 400,
              ),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SingleChildScrollView(
                child: Text(
                  widget.post.content,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            const Gap(),
            const Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            if (widget.post.isAnswered == 1)
              Row(
                children: [
                  const Icon(Icons.subdirectory_arrow_right),
                  Text(widget.post.responseTitle ?? ''),
                  const Gap(),
                ],
              ),
            if (widget.post.responseContent != null) ...[
              const Gap(),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  minHeight: 100,
                  maxHeight: 200,
                ),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    widget.post.responseContent!,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
