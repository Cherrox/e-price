import 'package:e_price/src/screen.dart';
import 'package:flutter/material.dart';

class MaterialButtomWidget extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onPressed;
  final EdgeInsets margin;
  final double? height;
  final double? fontSize;
  final IconData? icon;

  const MaterialButtomWidget(
      {super.key,
      required this.title,
      required this.color,
      required this.onPressed,
      this.margin = const EdgeInsets.symmetric(horizontal: 20),
      this.height = 50,
      this.fontSize = 18,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      elevation: 10,
      //color: color,
      shadowColor: AppColors.orangeAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: SizedBox(
        width: double.infinity,
        child: MaterialButton(
          height: height,
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: icon == Icons.onetwothree
                        ? (fontSize ?? 25) + 20.00
                        : (fontSize ?? 25) + 10.00,
                  ),
                ),
              // const SizedBox(
              //   width: 5,
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: fontSize,
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
