// ignore_for_file: unrelated_type_equality_checks, avoid_print, use_build_context_synchronously, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_price/src/screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  RegisterProvider() {
    checkSign();
  }

  void checkSign() async {
    await LocalStorage.configureBox();

    _isSignedIn = LocalStorage.box.get("is_signedin") ?? false;
    notifyListeners();
  }

  Future<void> setSignedIn() async {
    await LocalStorage.configureBox();

    LocalStorage.box.put("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  Future<void> checkLoggedIn(BuildContext context) async {
    final authProvider = Provider.of<AuthProviderP>(context);
    await Future.delayed(
        const Duration(seconds: 2)); // Simulando tiempo de espera
    User? currentUser = authProvider.auth.currentUser;
    if (currentUser != null) {
      // Usuario ya ha iniciado sesión
      authProvider.getLoading(false);
    } else {
      authProvider.getLoading(false);
    }
    notifyListeners();
  }

//PARA REGISTRAR USUARIOS
  Future<void> registerUser({
    required String email,
    required String password,
    required String token,
    //required Function onSuccess,
    required Function(String) onError,
    required BuildContext context,
  }) async {
    try {
      final authProvider = Provider.of<AuthProviderP>(context, listen: false);

      // Convertir el correo electrónico a minúsculas
      final String emailLower = email.toLowerCase();

      //verificar si el correo ya esta registrado
      final QuerySnapshot result = await authProvider.firestore
          .collection('users')
          .where('email', isEqualTo: emailLower)
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        onError('Ya existe una cuenta con este correo electrónico');
        return;
      }

      UserCredential userCredential =
          await authProvider.auth.createUserWithEmailAndPassword(
        email: emailLower,
        password: password,
      );

      // Obtener la fecha y hora actual
      DateTime now = DateTime.now();

      final User user = userCredential.user!;
      //IDENTIFICADOR UNICO PARA EL USUARIO
      String userId = user.uid;
      String username = emailLower.split('@').first;

      //ref a la coleccion de usuarios
      final userRef = authProvider.firestore.collection('users');

      final userData = {
        'id': userId,
        'username': username,
        'username_lowercase': emailLower.split('@').first.toLowerCase(),
        'email': emailLower,
        'password': password,
        'birth': '',
        'nameAndApellido': '',
        'sexo': "",
        'direccion': "",
        'imageUser': "",
        'telefono': "",
        'biografia': "Soy $username",
        'createdAt': now,
        'edad': '',
        'token': token,
        'estado': 'offline',
        'rol': 'user',
      };

      // Guardar los datos del usuario en Firestore
      await userRef.doc(userId).set(userData);
      // Enviar un correo electrónico de verificación
      await user.sendEmailVerification();
      // Mostrar un mensaje de éxito
      showSnackbar(
          context, 'Registro exitoso. El usuario debe verificar su correo.');
      authProvider.getLoading(false);
      //limpiar los campos
      authProvider.emailController.clear();
      authProvider.passwordController.clear();
      // Cerrar la pantalla de registro
      Navigator.pop(context);
      // Llamar al método onSuccess después de guardar los datos del usuario
      //onSuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        onError('La contraseña es demasiado débil');
      } else if (e.code == 'email-already-in-use') {
        onError('Ya existe una cuenta con este correo electrónico');
      } else {
        onError('Ha ocurrido un error durante el registro');
      }
    } catch (e) {
      onError('Ha ocurrido un error durante el registro');
    }
  }

//ELIMINAR CUENTA DE USUARIO
  Future<void> deleteAccount(BuildContext context) async {
    try {
      // Obtén el usuario actual
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        // No hay usuario autenticado
        showSnackbar(context, 'No hay usuario autenticado');
        print('No hay usuario autenticado');
        return;
      }

      // Mostrar un diálogo de confirmación
      bool confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppColors.darkColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            titleTextStyle: const TextStyle(
                fontFamily: "CB",
                color: AppColors.blueColors,
                fontSize: 20,
                letterSpacing: 0.5),
            contentTextStyle: const TextStyle(
                fontFamily: "CB",
                color: AppColors.white,
                fontSize: 17,
                letterSpacing: 0.5),
            title: const Text(
              'Confirmar eliminación',
              textAlign: TextAlign.center,
            ),
            content: const Text(
              '¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.',
              textAlign: TextAlign.center,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    color: AppColors.orangeAccent,
                    splashColor: AppColors.orangeAccent.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                          fontFamily: "CB",
                          color: AppColors.darkColor,
                          fontSize: 17),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 20),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: AppColors.orangeAccent.withOpacity(0.8),
                    splashColor: AppColors.orangeAccent,
                    child: const Text(
                      'Eliminar',
                      style: TextStyle(
                          fontFamily: "CB",
                          color: AppColors.darkColor,
                          fontSize: 17),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );

      if (confirmed != true) {
        // El usuario canceló la eliminación
        showSnackbar(context, "Se cancelo la eliminación de la cuenta");
        return;
      }

      final userId = currentUser.uid;

      // Eliminar la imagen del usuario en el almacenamiento
      final firebaseStorageRef =
          FirebaseStorage.instance.ref().child('users').child('$userId.jpg');
      await firebaseStorageRef.delete();

      // Eliminar el documento correspondiente de Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

      // Eliminar el usuario de la autenticación
      await currentUser.delete();

      // Mostrar un mensaje de éxito y redirigir a la pantalla de inicio de sesión y registro
      showSnackbar(context, 'Cuenta eliminada exitosamente');
      print('Cuenta eliminada exitosamente');
      Navigator.pushNamedAndRemoveUntil(
          context, '/login_and_register', (route) => false);
    } catch (e) {
      // Mostrar un mensaje de error
      showSnackbar(context, "Se cancelo la eliminación de la cuenta");
      print('Error al eliminar la cuenta: $e');
    }
  }
}
