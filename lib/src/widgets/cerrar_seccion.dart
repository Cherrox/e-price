// ignore_for_file: use_build_context_synchronously

import 'package:e_price/src/screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CerrarSeccion extends StatelessWidget {
  const CerrarSeccion({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          //color: AppColors.blueOscureA,
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
        onPressed: () async {
          final confirm = await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor:
                     AppColors.darkColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Text(
                "Cerrar sesión",
                style: TextStyle(
                  fontFamily: "MonB",
                  color: AppColors.blueColors,
                ),
                textAlign: TextAlign.center,
              ),
              content: const Text(
                "¿Estás seguro de que deseas cerrar sesión?",
                style: TextStyle(
                  fontFamily: "MonM",
                  color:
                       AppColors.headerColor,
                ),
                textAlign: TextAlign.center,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      color: AppColors.orangeAccent,
                      splashColor: AppColors.blueColors,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        Navigator.of(context).pop(false); // No confirmado
                      },
                      child: const Text(
                        "No",
                        style: TextStyle(
                          fontFamily: "MonB",
                          color: AppColors.darkColor,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    MaterialButton(
                      color: AppColors.blueColors.withOpacity(0.8),
                      splashColor: AppColors.orangeAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        Navigator.of(context).pop(true); // Confirmado
                      },
                      child: const Text(
                        "Sí",
                        style: TextStyle(
                          fontFamily: "MonB",
                          color: AppColors.darkColor,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          );

          if (confirm == true) {
            await Provider.of<AuthProviderP>(context, listen: false)
                .logoutApp();
            //navegar al login reemplazando todas las rutas
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.login, (route) => false);
          }
        },
        icon: Image.asset(
          "assets/icons/salir.png",
          color:  AppColors.darkColor,
          height: 35,
          width: 35,
        ),
      ),
    );
  }
}
