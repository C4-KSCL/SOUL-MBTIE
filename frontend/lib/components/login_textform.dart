// ignore_for_file: unused_local_variable, prefer_const_constructors

import 'package:flutter/material.dart';

class LoginTextForm extends StatefulWidget {
  //logo는 이미지, type은 아이디인지 패스워드인지
  final String textLogo;
  final String textType;
  final TextEditingController typeController;

  LoginTextForm({
    required this.typeController,
    required this.textLogo,
    required this.textType,
  });

  @override
  State<LoginTextForm> createState() => _LoginTextFormState();
}

class _LoginTextFormState extends State<LoginTextForm> {
  @override
  Widget build(BuildContext context) {
    String textLogo = widget.textLogo;
    String textType = widget.textType;
    TextEditingController typeController = widget.typeController;
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
            Container(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: TextFormField(
                obscureText: true,
                controller: widget.typeController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: '입력해주세요',
                  //둥근 테두리 만들어주는 위젯
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  //텍스트 폼 필드가 선택됐을 때 테두리가 파란색으로 변함.
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Colors.blue)),
                ),
              ),
            ),
          ],
        ));
  }
}
