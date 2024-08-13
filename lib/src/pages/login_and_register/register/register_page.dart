// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:e_price/src/screen.dart';
import 'package:e_price/src/widgets/auth_background.dart';
import 'package:e_price/src/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static String? token;
  @override
  void initState() {
    super.initState();
    token = PushNotificationService.token;
  }

  void _submitForm() async {
    final authProvider = Provider.of<AuthProviderP>(context, listen: false);
    final registerProvider =
        Provider.of<RegisterProvider>(context, listen: false);
    authProvider.getLoading(true);
    //cerrar teclado
    FocusScope.of(context).unfocus();
    if (!authProvider.formKeyR.currentState!.validate()) {
      authProvider.getLoading(false);
      return;
    }
    authProvider.formKeyR.currentState!.save();
    final String email = authProvider.emailController.text;
    final String password = authProvider.passwordController.text;

    await registerProvider.registerUser(
      email: email,
      password: password,
      token: token!,
      onError: (String errorMessage) {
        authProvider.getLoading(false);
        authProvider.errorMessage = errorMessage;
      },
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderP>(context);
    final isLoading = authProvider.isLoading;
    final isLoginGoogle = authProvider.isLoginGoogle;

    return Scaffold(
      backgroundColor: AppColors.headerColor,
      body: AuthBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                CardContainer(
                  child: Form(
                    key: authProvider.formKeyR,
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        const Text(
                          "Registro",
                          style: TextStyle(
                            color: AppColors.orangeAccent,
                            fontSize: 25,
                            fontFamily: "MonB",
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 25),
                        InputDecorationWidget(
                          hintText: "usuario@gmail.com o usuario00",
                          labelText: "Ingresa con tu correo o usuario",
                          prefixIcon: const Icon(Icons.person),
                          keyboardType: TextInputType.emailAddress,
                          controller: authProvider.emailController,
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 20),
                        InputDecorationWidget(
                          hintText: "Contraseña",
                          labelText: "Ingresa tu contraseña",
                          prefixIcon: const Icon(Icons.lock),
                          maxLines: 1,
                          suffixIcon: IconButton(
                            icon: Icon(
                              authProvider.obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                authProvider.obscureText = !authProvider.obscureText;
                              });
                            },
                          ),
                          obscureText: authProvider.obscureText,
                          controller: authProvider.passwordController,
                          validator: Validators.validatePassword,
                        ),
                        const SizedBox(height: 40),
                        isLoading
                            ? const CircularProgressWidget(
                                text: "Verificando", color: AppColors.orange)
                            : MaterialButtomWidget(
                                color: AppColors.orange,
                                onPressed: _submitForm,
                                title: 'Registrar',
                              ),
                        const SizedBox(height: 20),
                        isLoginGoogle
                            ? const CircularProgressWidget(
                                text: "Validando...",
                                color: AppColors.orange,
                              )
                            : ButtomDecorationWidget(
                              margin: const EdgeInsets.all(0),
                                icon: "assets/icons/googleB.png",
                                color: AppColors.orange,
                                iconColor: AppColors.white,
                                onPressed: () {
                                  Provider.of<AuthProviderP>(context, listen: false)
                                      .registerWithGoogle(context, token);
                                },
                                textIcon: "Registrar con Google",
                                
                              ),
                        const SizedBox(height: 20),
                      
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                  CuentaWidget(
                          pregunta: "¿Ya tienes cuenta?",
                          accion: "Inicia de sesión",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
