import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InfoModifyButton extends StatelessWidget {
  final String str;
  final String img;
  final Function()? pressed;
  final double medHeight;
  final double medWidth;

  InfoModifyButton({
    required this.pressed,
    required this.img,
    required this.str,
    required this.medHeight,
    required this.medWidth,
  });

  @override
  Widget build(BuildContext context) {
    // 이미지가 SVG인지 아닌지에 따라 조건적으로 위젯을 결정
    Widget imageWidget() {
      if (img.endsWith('.svg')) {
        // SVG 파일인 경우
        return SvgPicture.asset(
          img,
          height: medHeight / 20,
          width: medHeight / 20,
          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          img,
          height: medHeight / 20,
          width: medHeight / 20,
          fit: BoxFit.cover,
        );
      }
    }

    return TextButton(
        onPressed: pressed,
        child: Container(
          height: medHeight / 5.5,
          width: medWidth / 2.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Color.fromARGB(255, 216, 216, 216), width: 0.3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: medHeight / 20,
                width: medHeight / 20,
                child: imageWidget(),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      str,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
