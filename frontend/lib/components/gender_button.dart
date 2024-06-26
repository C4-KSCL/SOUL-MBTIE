// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';

class GenderButton extends StatefulWidget {
  final void Function(int) onGenderSelected;

  const GenderButton({Key? key, required this.onGenderSelected})
      : super(key: key);

  @override
  State<GenderButton> createState() => _GenderButtonState();
}

class _GenderButtonState extends State<GenderButton> {
  int selected = 0;

  Widget customRadio(String text, int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selected = index;
        });

        widget.onGenderSelected(selected);
      },
      child: Text(
        text,
        style: TextStyle(
          color: (selected == index) ? Colors.white : Color(0xFF7EA5F3),
        ),
      ),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: (selected == index) ? Color(0xFF7EA5F3) : Colors.white,
        minimumSize: Size(140, 40),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          customRadio("남", 1),
          SizedBox(
            width: 20,
          ),
          customRadio("여", 2),
        ],
      ),
    );
  }
}
