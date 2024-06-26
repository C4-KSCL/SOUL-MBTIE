import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_matching/controllers/service_center_controller.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/post.dart';
import 'package:frontend_matching/models/post_image.dart';
import 'package:frontend_matching/pages/profile/service_center/detail_page.dart';
import 'package:frontend_matching/pages/profile/service_center/post_page.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';

class ServiceCenterPage extends StatefulWidget {
  const ServiceCenterPage({super.key});

  @override
  State<ServiceCenterPage> createState() => _ServiceCenterPageState();
}

class _ServiceCenterPageState extends State<ServiceCenterPage> {
  final ServiceCenterController serviceCenterController =
      ServiceCenterController();
  List<Post> posts = [];
  List<PostImage> images = [];
  bool isLoading = true;
  String accessToken = '';

  @override
  void initState() {
    super.initState();
    final UserDataController controller = Get.find<UserDataController>();
    accessToken = controller.accessToken;
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final data = await serviceCenterController.fetchPosts(accessToken);
      setState(() {
        posts = data['posts'];
        images = data['images'];
        isLoading = false;
      });
    } catch (e) {
      print('Failed to load posts: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: blueColor5,
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
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : posts.isEmpty
                ? const Center(child: Text('게시글이 없습니다.'))
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      final image = images.firstWhereOrNull(
                        (img) => img.postNumber == post.postNumber,
                      );

                      return ListTile(
                        leading: image != null
                            ? Image.network(image.imagePath)
                            : null,
                        title: Text(post.title),
                        subtitle: Text(post.content), //
                        trailing: Text(
                          post.isAnswered == 0 ? '답변대기중' : '답변완료',
                          style: TextStyle(
                            fontSize: 13,
                            color:
                                post.isAnswered == 0 ? Colors.red : Colors.blue,
                          ),
                        ),
                        onTap: () {
                          Get.to(() => DetailPage(
                                post: post,
                                postImage: image,
                              ));
                        },
                      );
                    },
                  ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
          child: FloatingActionButton(
              backgroundColor: blueColor1,
              onPressed: () {
                Get.to(() => PostPage());
              },
              child: SvgPicture.asset('assets/icons/document.svg')),
        ));
  }
}
