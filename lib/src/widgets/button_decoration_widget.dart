import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class ButtonDecorationWidget extends StatelessWidget {
  const ButtonDecorationWidget({
    super.key,
    required this.onPressed,
    required this.margin,
    required this.text,
    this.icon,
    this.icon2,
    this.color,
  });

  final void Function() onPressed;
  final EdgeInsetsGeometry margin;
  final String text;
  final dynamic color;
  final IconData? icon;
  final Widget? icon2;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: CupertinoButton(
        minSize: 0,
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:
                  color != null ? AppColors.pink : AppColors.orange,
              border: Border.all(width: 1, color: Colors.white)),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: icon != null,
                child: Icon(icon, color: AppColors.pink, size: 30),
              ),
              Visibility(
                visible: icon != null,
                child: const SizedBox(width: 15),
              ),
              Text(
                text,
                style: TextStyle(
                    color:
                        color != null ? AppColors.orangeAccent : AppColors.white,
                    fontFamily: "MonB",
                    fontSize: 18,
                    letterSpacing: 0.5),
                textAlign: TextAlign.center,
              ),
              Visibility(
                visible: icon2 != null,
                child: const SizedBox(width: 15),
              ),
              Visibility(
                  visible: icon2 != null,
                  child:  icon2 ?? Container()
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
