import 'package:flutter/material.dart';

class RowButton extends StatelessWidget {
  final String str;
  final String img;
  final Function()? pressed;
  final double medHeight;
  final double medWidth;

  RowButton(
      {required this.pressed,
      required this.img,
      required this.str,
      required this.medHeight,
      required this.medWidth});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: pressed,
        child: Container(
          height: medHeight / 9,
          width: medWidth / 5.5,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Color.fromARGB(255, 216, 216, 216), width: 0.3)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: medHeight / 20,
                  width: medHeight / 20,
                  child: Image.asset(
                    img,
                    fit: BoxFit.cover,
                  )),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$str',
                      style: TextStyle(
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
