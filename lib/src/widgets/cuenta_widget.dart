import 'package:e_price/src/screen.dart';
import 'package:flutter/material.dart';

class CuentaWidget extends StatelessWidget {
  final String pregunta;
  final String accion;
  final VoidCallback onPressed;

  const CuentaWidget({
    super.key,
    required this.pregunta,
    required this.accion,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          pregunta,
          style: const TextStyle(
            color: AppColors.greyColors,
            fontFamily: "MonM",
            fontSize: 15,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            accion,
            style: const TextStyle(
              color: AppColors.pink,
              fontFamily: "MonB",
              fontSize: 16,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.orange,
            ),
          ),
        ),
      ],
    );
  }
}
