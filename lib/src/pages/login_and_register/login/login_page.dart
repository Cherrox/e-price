// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:e_price/src/screen.dart';
import 'package:e_price/src/widgets/auth_background.dart';
import 'package:e_price/src/widgets/card_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static String? token;
  late bool _isFirstTimeUser;
  bool carga = false;
  late Future<void> cargaFuture;

  @override
  void initState() {
    super.initState();
    token = PushNotificationService.token;
    _initPrefs();
    cargaFuture = _showCarga();
  }

  @override
  void dispose() {
    // Cancela cualquier operación asíncrona aquí si es necesario
    super.dispose();
  }


  Future<void> _initPrefs() async {
    final userBox = await Hive.openBox('user');
    _isFirstTimeUser = !userBox.containsKey('hasLoggedInBefore');

    if (_isFirstTimeUser) {
      userBox.put('hasLoggedInBefore', true);
      var d = const Duration(seconds: 4);
      Future.delayed(d, _navigateToInicioScreen);
    } else {
      _navigateToInicioScreen();
    }
  }

  void _navigateToInicioScreen() async {
    final authProvider = Provider.of<AuthProviderP>(context, listen: false);
    final userBox = await Hive.openBox('user');
    final bool isLoggedIn = userBox.get('isLoggedIn', defaultValue: false);
    final user = authProvider.auth.currentUser;
    if (user != null && user.email != null && user.emailVerified) {
      // Obtener los datos del usuario desde la base de datos
      dynamic userData = await authProvider.getUserData(user.email!);

      // Mueve la verificación de isLoggedIn aquí
      if (isLoggedIn) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) {
            return InicioScreen(
              userData: userData,
            );
          },
        ), (route) => false);
        showSnackbar(context, "Bienvenido de nuevo! ${userData['username']}");
      } else {
        userBox.put('isLoggedIn', true);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => InicioScreen(
              userData: userData,
            ),
          ),
        );
        showSnackbar(context, "Bienvenido de nuevo! ${userData['username']}");
      }
    } else {
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => const LoginPage(),
      //   ),
      // );
    }
  }

  //mostrar carga por 2 segundos mientras se valida el usuario
  Future<void> _showCarga() async {
    setState(() {
      carga = true;
    });
    await Future.delayed(const Duration(seconds: 10));
    if (mounted) {
      setState(() {
        carga = false;
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderP>(context);
    final isLoading = authProvider.isLoading;
    final isLoginGoogle = authProvider.isLoginGoogle;
    final loginProvider = Provider.of<LoginProvider>(context);
     if (carga) {
    return const Scaffold(
      body: Center(
        child: CircularProgressWidget(
          color: AppColors.orange,
          text: "Cargando...",
        ),
      ),
    );
  } else {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 220),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    const Text('INGRESAR',
                        style: TextStyle(
                            color: AppColors.orange,
                            fontSize: 20,
                            fontFamily: "MonB")),
                    const SizedBox(height: 20),
                    Form(
                      key: authProvider.formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          InputDecorationWidget(
                            hintText: 'Ingresa correo o usuario',
                            labelText: 'Correo o Usuario',
                            suffixIcon: const Icon(CupertinoIcons.person_alt),
                            controller: authProvider.emailOrUsernamecontroller,
                            validator: Validators.emailUsernameValidator,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 15),
                          
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
                                  authProvider.obscureText =
                                      !authProvider.obscureText;
                                });
                              },
                            ),
                            obscureText: authProvider.obscureText,
                            controller: authProvider.passwordController,
                            validator: Validators.validatePassword,
                          ),
                          const SizedBox(height: 30),
                          isLoading
                              ? const CircularProgressWidget(
                                  color: AppColors.orange, text: "Verificando")
                              : MaterialButtomWidget(
                                  color: AppColors.orange,
                                  onPressed: () {
                                    //validar formulario
                                    if (authProvider.formKey.currentState!
                                        .validate()) {
                                      authProvider.formKey.currentState!.save();
                                      loginProvider.loginUser(
                                        usernameOrEmail: authProvider
                                            .emailOrUsernamecontroller.text,
                                        password: authProvider
                                            .passwordController.text,
                                        token: token.toString(),
                                        context: context,
                                      );
                                    }
                                  },
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  title: "Ingresar",
                                ),
                          const SizedBox(height: 15),
                          isLoginGoogle
                              ? const CircularProgressWidget(
                                  color: AppColors.orange, text: "Validando...")
                              : ButtomDecorationWidget(
                                  icon: "assets/icons/google.png",
                                  color: AppColors.white,
                                  onPressed: () {
                                    Provider.of<AuthProviderP>(context,
                                            listen: false)
                                        .signInWithGoogle(context, token);
                                  },
                                  textIcon: "Ingresa con Google",
                                  textColor: AppColors.blueColors,
                                ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecoveryPassword(),
                    ),
                  );
                },
                child: const Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(
                    color: AppColors.orange,
                    fontFamily: "MonB",
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.orange,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿No tienes cuenta?',
                    style: TextStyle(
                        color: AppColors.blueColors,
                        fontFamily: "MonM",
                        fontSize: 15),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const RegisterPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = const Offset(1.0, 0.0);
                            var end = Offset.zero;
                            var tween = Tween(begin: begin, end: end);
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: const Text(
                      'Regístrate',
                      style: TextStyle(
                          color: AppColors.orange,
                          fontFamily: "MonB",
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  }
}
