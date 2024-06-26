// import 'package:flutter/material.dart';
// import 'package:frontend_matching/theme/colors.dart';
// import 'package:frontend_matching/theme/text_style.dart';

// class GetTextContainer extends StatefulWidget {
//   final TextEditingController typeController;
//   final String textLogo;
//   final String textType;
//   final Function(String)? onChanged;

//   GetTextContainer({
//     required this.typeController,
//     required this.textLogo,
//     required this.textType,
//     this.onChanged,
//   });

//   @override
//   State<GetTextContainer> createState() => _GetTextContainerState();
// }

// class _GetTextContainerState extends State<GetTextContainer> {
//   bool get isPassword => widget.textType == '비밀번호';

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 5.0,
//             spreadRadius: 1.0,
//             offset: const Offset(5, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Text(
//               widget.textType,
//               style: TextStyle(fontSize: 15),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
//             child: TextFormField(
//               controller: widget.typeController,
//               keyboardType: TextInputType.text,
//               obscureText: isPassword,
//               decoration: InputDecoration(
//                 hintText: isPassword ? '비밀번호를 입력해주세요' : '입력해주세요',
//                 hintStyle: greyTextStyle1,
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: whiteColor1, width: 2.0),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: whiteColor1, width: 2.0),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onChanged: widget.onChanged,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/text_style.dart';

class GetTextContainer extends StatefulWidget {
  final TextEditingController typeController;
  final String textLogo;
  final String textType;
  final Function(String)? onChanged;

  GetTextContainer({
    required this.typeController,
    required this.textLogo,
    required this.textType,
    this.onChanged,
  });

  @override
  State<GetTextContainer> createState() => _GetTextContainerState();
}

class _GetTextContainerState extends State<GetTextContainer> {
  bool get isPassword => widget.textType == '비밀번호';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: TextFormField(
                  controller: widget.typeController,
                  keyboardType: TextInputType.text,
                  obscureText: isPassword,
                  decoration: InputDecoration(
                    hintText: isPassword ? '비밀번호를 입력해주세요' : '입력해주세요',
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
                  onChanged: widget.onChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
