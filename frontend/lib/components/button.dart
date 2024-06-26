import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

SizedBox ColorBottomButton({
  required String text,
  required Color backgroundColor,
  required VoidCallback onPressed,
  required TextStyle textStyle,
}) {
  return SizedBox(
    width: 400,
    height: 50,
    child: TextButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: backgroundColor,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Measure text width
          final textPainter = TextPainter(
            text: TextSpan(text: text, style: textStyle),
            maxLines: 1,
            textDirection: TextDirection.ltr,
          )..layout();

          // Check if text width exceeds button width
          final isTextOverflowing = textPainter.size.width > constraints.maxWidth;

          if (isTextOverflowing) {
            return Marquee(
              text: text,
              style: textStyle,
              scrollAxis: Axis.horizontal,
              blankSpace: 20.0,
              velocity: 50.0,
              pauseAfterRound: const Duration(seconds: 1),
              startPadding: 10.0,
              showFadingOnlyWhenScrolling: true,
              fadingEdgeStartFraction: 0.1,
              fadingEdgeEndFraction: 0.1,
            );
          } else {
            return Text(
              text,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            );
          }
        },
      ),
    ),
  );
}

Container WhiteBottomButton(
    {required String text,
    required Color backgroundColor,
    required VoidCallback onPressed,
    required TextStyle textStyle}) {
  return Container(
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
    width: 400,
    height: 50,
    child: TextButton(
      onPressed: () {
        onPressed();
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: backgroundColor,
      ),
      child: Text(text, style: textStyle),
    ),
  );
}
