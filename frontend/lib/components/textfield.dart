import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/text_style.dart';
import 'package:flutter/services.dart';

// 버튼이 들어있는 텍스트 필드
class ButtonTextFieldBox extends StatefulWidget {
  final String hintText;
  final VoidCallback onPressed;
  final String buttonText;
  final TextEditingController textEditingController;
  final String textType;

  ButtonTextFieldBox({
    required this.hintText,
    required this.onPressed,
    required this.buttonText,
    required this.textEditingController,
    required this.textType,
  });

  @override
  _ButtonTextFieldBoxState createState() => _ButtonTextFieldBoxState();
}

class _ButtonTextFieldBoxState extends State<ButtonTextFieldBox> {
  bool _hasInput = false;

  @override
  void initState() {
    super.initState();
    widget.textEditingController.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    widget.textEditingController.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    setState(() {
      _hasInput = widget.textEditingController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            widget.textType,
            style: TextStyle(fontSize: 15),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5.0,
                spreadRadius: 1.0,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: TextField(
            controller: widget.textEditingController,
            decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: greyTextStyle1,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: whiteColor1, width: 2.0),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: blueColor4, width: 2.0),
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 80,
                    child: ElevatedButton(
                      onPressed: _hasInput ? widget.onPressed : null,
                      child: Container(
                        child: Text(
                          widget.buttonText,
                          style: _hasInput ? blueTextStyle1 : greyTextStyle1,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // 원하는 반지름 값으로 설정
                        ),
                        side: BorderSide(
                          color: _hasInput ? blueColor4 : greyColor7,
                          // 원하는 테두리 색깔로 설정
                          width: 2, // 테두리의 두께 설정
                        ),
                      ),
                    ),
                  ),
                )),
          ),
        ),
      ],
    );
  }
}

Column IconTextFieldBox({
  required TextEditingController textEditingController,
  required String hintText,
  required VoidCallback onPressed,
  String textType = '',
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (textType.isNotEmpty) // textType이 비어 있지 않을 때만 Text 위젯
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            textType,
            style: TextStyle(fontSize: 15),
          ),
        ),
      Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5.0,
              spreadRadius: 1.0,
              offset: const Offset(5, 5), // 그림자의 위치
            ),
          ],
        ),
        child: TextField(
          style: blackTextStyle2,
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle: greyTextStyle1,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: blueColor4, width: 2.0),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: blueColor4, width: 2.0),
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: IconButton(
                  onPressed: () {
                    onPressed();
                  },
                  icon: SvgPicture.asset('assets/icons/send_button.svg'),
                ),
              )),
          controller: textEditingController,
        ),
      ),
    ],
  );
}

class NumberInputField extends StatelessWidget {
  final TextEditingController controller; // TextEditingController 추가
  final String hintText; // hintText 추가
  final String textType; // textType 추가

  // 생성자에서 필수 매개변수로 받음
  NumberInputField({
    required this.controller,
    required this.hintText,
    required this.textType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            textType,
            style: TextStyle(fontSize: 15),
          ),
        ),
        Container(
          width: 140,
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5.0,
                spreadRadius: 1.0,
                offset: const Offset(5, 5), // 그림자의 위치
              ),
            ],
          ),
          child: TextField(
            controller: controller, // 사용할 컨트롤러
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              hintText: hintText, // hintText 사용
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
            ),
          ),
        ),
      ],
    );
  }
}
