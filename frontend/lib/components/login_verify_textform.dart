import 'package:flutter/material.dart';

class LoginVerifyTextform extends StatefulWidget {
  final String textType;
  final TextEditingController typeController;

  LoginVerifyTextform({
    required this.typeController,
    required this.textType,
  });

  @override
  State<LoginVerifyTextform> createState() => _LoginVerifyTextformState();
}

class _LoginVerifyTextformState extends State<LoginVerifyTextform> {
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
                  //둥근 테두리 만들어주는 위젯
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  //텍스트 폼 필드가 선택됐을 때 테두리가 파란색으로 변함.
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Colors.blue)),
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
