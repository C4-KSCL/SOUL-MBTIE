import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ColumnButton extends StatelessWidget {
  final Function()? pressed;
  final String img;
  final String str;

  ColumnButton({required this.pressed, required this.img, required this.str});

  @override
  Widget build(BuildContext context) {

    return TextButton(
        onPressed: pressed,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey, width: 0.1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                img,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                '$str',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ));
  }
}
