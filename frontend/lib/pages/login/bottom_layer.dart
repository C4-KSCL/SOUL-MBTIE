// ignore_for_file: duplicate_import, unused_import

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_matching/components/login_textform.dart';
import 'package:frontend_matching/components/login_verify_textform.dart';
import 'package:frontend_matching/components/textform_field.dart';
import 'package:frontend_matching/components/textform_verify.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/user.dart';
import 'package:frontend_matching/pages/init_page.dart';
import 'package:frontend_matching/pages/login/find_password_page.dart';
import 'package:frontend_matching/pages/matching/main_page.dart';
import 'package:frontend_matching/pages/signup/school_auth_page.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:http/http.dart' as http;

class BottomLayerLoginScreen extends StatefulWidget {
  const BottomLayerLoginScreen({super.key});

  @override
  State<BottomLayerLoginScreen> createState() => _BottomLayerLoginScreenState();
}

class _BottomLayerLoginScreenState extends State<BottomLayerLoginScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '로그인',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              LoginVerifyTextform(
                typeController: idController,
                textType: '이메일',
              ),
              LoginTextForm(
                  typeController: pwController, textLogo: '', textType: '비밀번호'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // TextButton(
                  //     onPressed: () {},
                  //     child: const Text(
                  //       '이메일 찾기',
                  //       style: TextStyle(
                  //           color: Colors.grey,
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w800,
                  //           decoration: TextDecoration.underline),
                  //     )),
                  TextButton(
                      onPressed: () {
                        Get.to(()=>const FindPasswordPage());
                      },
                      child: const Text(
                        '비밀번호 찾기',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.underline),
                      )),
                ],
              ),
              const SizedBox(
                  width: 500,
                  child: Divider(color: Colors.blueGrey, thickness: 2.0)),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueColor1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () async {
                      String email = idController.text;
                      String password = pwController.text;
                      print("login check");
                      await UserDataController.to.loginUser(email, password);
                      if(UserDataController.to.user.value!=null){
                        Get.off(const InitPage());
                      } else if(UserDataController.to.user.value==null){
                        Get.snackbar("로그인 실패", "이메일과 비밀번호를 확인해주세요.");
                      }
                    },
                    child: const Text(
                      '로그인하기',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {
                      Get.to(()=>const SchoolAuthPage());
                    },
                    child: const Text(
                      '회원가입하기',
                      style: TextStyle(fontSize: 16, color: Color(0xFF61A6FA)),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
