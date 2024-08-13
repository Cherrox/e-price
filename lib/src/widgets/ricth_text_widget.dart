import 'package:e_price/src/screen.dart';
import 'package:flutter/material.dart';


class WidgetRichText extends StatelessWidget {
  final String text;
  final String text2;
  final String text3;
  final dynamic textAlign;
  final Color titleColor;
  final Color contentColor;
  const WidgetRichText({
    super.key,
    required this.text,
    required this.text2,
    required this.text3,
    required this.textAlign,
    this.titleColor = AppColors.black,
    this.contentColor = AppColors.orangeAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: RichText(
        textAlign: textAlign,
        text: TextSpan(
          style: const TextStyle(fontSize: 16),
          children: [
            TextSpan(text: text, style: TextStyle(color: titleColor,fontFamily: "PB")),
            TextSpan(
                text: text2,
                style: TextStyle(color: contentColor,fontFamily: "PR")),
            TextSpan(text: text3, style: TextStyle(color: contentColor,fontFamily: "PR")),
          ],
        ),
      ),
    );
  }
}
