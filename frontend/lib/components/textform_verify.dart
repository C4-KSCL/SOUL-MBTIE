import 'package:flutter/material.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/text_style.dart';

class TextformVerify extends StatefulWidget {
  final String textType;
  final TextEditingController typeController;

  TextformVerify({
    required this.typeController,
    required this.textType,
  });

  @override
  State<TextformVerify> createState() => _TextformVerifyState();
}

class _TextformVerifyState extends State<TextformVerify> {
  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[\w\.-]+@stu\.kmu\.ac\.kr$');

    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      return 'Please enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String textType = widget.textType;
    return Container(
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
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //아이디 입력창 위 아이콘 및 '아이디' 텍스트
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 5,
              ),
              Text(
                widget.textType,
                style: const TextStyle(fontSize: 15),
              )
            ],
          ),
          // 아이디 입력 창
          Form(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: TextFormField(
                controller: widget.typeController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: '$textType를 입력해주세요',
                  hintStyle: greyTextStyle1,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: whiteColor1, width: 2.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: blueColor4, width: 2.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: validateEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
