// ignore_for_file: deprecated_member_use

import 'package:e_price/src/pages/login_and_register/login/login_page.dart';
import 'package:e_price/src/utils/app_colors.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: AppColors.darkColor,
        content: Text(
          message,
          style: const TextStyle(color: AppColors.white, fontFamily: "MonB"),
        ),
      ),
    );
  }
}

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: AppColors.orange,
      content: Text(
        message,
        style: const TextStyle(color: AppColors.white, fontFamily: "MonB"),
      ),
    ),
  );
}

Future<dynamic> dialogoDeConfirmacion(
  BuildContext context,
  String title,
  String description,
) {
  // Crear un nuevo GlobalKey para el Navigator del diálogo
  final GlobalKey<NavigatorState> dialogNavigatorKey =
      GlobalKey<NavigatorState>();

  return showDialog(
    context: context,
    builder: (_) => WillPopScope(
      onWillPop: () async {
        // Redirigir al usuario a la página de inicio de sesión al presionar "Atrás"
        dialogNavigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false, // Nunca permite volver atrás
        );
        return false; // Impedir el cierre del diálogo
      },
      child: Navigator(
        key: dialogNavigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: AppColors.darkColor,
              title: Text(
                title,
                style: const TextStyle(
                    fontFamily: "MonB", color: AppColors.orangeAccent),
                textAlign: TextAlign.center,
              ),
              content: Text(
                description,
                style:
                    const TextStyle(fontFamily: "MonM", color: AppColors.white),
                textAlign: TextAlign.center,
              ),
              actions: [
                Center(
                  child: MaterialButton(
                    color: AppColors.blueColors,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      //navegar reemplazando la pila de rutas
                      dialogNavigatorKey.currentState!.pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (Route<dynamic> route) =>
                            false, // Nunca permite volver atrás
                      );
                    },
                    child: const Text(
                      "Aceptar",
                      style: TextStyle(
                          fontFamily: "MonB", color: AppColors.darkColor),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}


