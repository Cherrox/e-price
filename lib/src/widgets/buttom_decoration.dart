import 'package:e_price/src/screen.dart';
import 'package:flutter/material.dart';

class ButtomDecorationWidget extends StatelessWidget {
  final String icon;
  final VoidCallback onPressed;
  final String textIcon;
  final Color color;
  final Color textColor;
  final Color iconColor;
  final EdgeInsets margin;
  const ButtomDecorationWidget({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.textIcon,
    this.color = AppColors.white,
    this.textColor = AppColors.white,
    this.iconColor = AppColors.orange,
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      elevation: 10,
      color: color,
      shadowColor: AppColors.pink,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: SizedBox(
        width: double.infinity,
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          color: color,
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: Image.asset(
                  icon,
                  height: 30,
                  color: iconColor,
                ),
              ),
              // const SizedBox(width: 10),
              FittedBox(
                child: Text(
                  textIcon,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15.0,
                    fontFamily: "MonB",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
