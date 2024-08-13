// ignore_for_file: unnecessary_this

import 'package:e_price/src/screen.dart';
import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;

  const CardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: _createCardShape(),
        child: this.child,
      ),
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: AppColors.blueColors,
            blurRadius: 20,
            offset: Offset(0, 5),
          )
        ],
      );
}
