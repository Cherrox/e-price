import 'package:e_price/src/screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecoveryPassword extends StatelessWidget {
  const RecoveryPassword({super.key});
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderP>(context);
    final isLoading = authProvider.isLoading;

    return Scaffold(
      backgroundColor: AppColors.headerColor,
      appBar: AppBar(
        backgroundColor: AppColors.headerColor,
        elevation: 0,
        title: const Text(
          "Recuperar contraseña",
          style: TextStyle(
            color: AppColors.orangeAccent,
            fontFamily: "MonB",
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.orangeAccent,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: SafeArea(
          child: Form(
            key: authProvider.formKeyRP,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  InputDecorationWidget(
                    //colorFondo: AppColors.white,
                    color: AppColors.greyColors,
                    borderRadius: BorderRadius.circular(20),
                    labelText: "Ingresa tu email",
                    hintText: "quienlohace@gmail.com",
                    controller: authProvider.emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                    prefixIcon: const Icon(
                      Icons.email,
                      color: AppColors.greyColors,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                      "Se enviará un correo electrónico con un enlace para restablecer tu contraseña.",
                      style: TextStyle(
                          color: AppColors.pink,
                          fontFamily: "MonM",
                          fontSize: 14),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 30),
                  isLoading
                      ? const CircularProgressWidget(
                          text: "Validando...",
                          color: AppColors.orangeAccent,
                        )
                      : MaterialButtomWidget(
                          color: AppColors.orangeAccent,
                          title: "Continuar",
                          onPressed: () {
                            authProvider.recoveryPassWord(
                                authProvider.emailController.text, context);
                          }),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
