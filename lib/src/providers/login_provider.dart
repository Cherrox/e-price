// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:e_price/src/screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginProvider extends ChangeNotifier {
  Future<void> loginUser({
    required String usernameOrEmail,
    required String password,
    required String token,
    required BuildContext context,
  }) async {
    try {
      final authProvider = Provider.of<AuthProviderP>(context, listen: false);
      authProvider.authStatus = AuthStatus.checking;
      final String usernameOrEmailLower = usernameOrEmail.toLowerCase();

      // Buscar usuario por nombre de usuario
      final QuerySnapshot userResult = await authProvider.firestore
          .collection('users')
          .where('username_lowercase', isEqualTo: usernameOrEmailLower)
          .limit(1)
          .get();

      if (userResult.docs.isNotEmpty) {
        final String email = userResult.docs.first.get('email');
        await _signInWithEmailAndPassword(
          email: email,
          password: password,
          token: token,
          context: context,
        );
        return;
      }

      // Buscar usuario por correo electrónico
      final QuerySnapshot emailResult = await authProvider.firestore
          .collection('users')
          .where('email', isEqualTo: usernameOrEmailLower)
          .limit(1)
          .get();

      if (emailResult.docs.isNotEmpty) {
        await _signInWithEmailAndPassword(
          email: emailResult.docs.first.get('email'),
          password: password,
          token: token,
          context: context,
        );
        return;
      }

      // Si no se encontró ningún usuario, mostrar un mensaje de error
      authProvider.getLoading(false);
      showSnackbar(context, "Nombre de usuario o contraseña incorrectos");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showSnackbar(context, "Nombre de usuario o contraseña incorrectos");
      } else {
        showSnackbar(context, "Ha ocurrido un error durante el inicio de sesión");
      }
    } catch (e) {
      showSnackbar(context, "Ha ocurrido un error durante el inicio de sesión");
    }
  }

  Future<void> _signInWithEmailAndPassword({
    required String email,
    required String password,
    required String token,
    required BuildContext context,
  }) async {
    final authProvider = Provider.of<AuthProviderP>(context, listen: false);

    final UserCredential userCredential = await authProvider.auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    authProvider.checkAuthStatus();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      final users = FirebaseFirestore.instance.collection('users');
      await users.doc(user.uid).update({'token': token});

      dynamic userData = await authProvider.getUserData(user.email!);
      final String username = userData['username'];
      showSnackbar(context, '¡Bienvenido, $username!');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InicioScreen(
              userData: userData,
            ),
          ),
        );
      });
    } else {
      showSnackbar(context, "Debes verificar tu correo electrónico antes de iniciar sesión.");
    }

    authProvider.getLoading(false);
  }

  // Método para obtener el rol del usuario
  Future<String?> getUserRol(String usernameOrEmail) async {
    final String usernameOrEmailLower = usernameOrEmail.toLowerCase();

    final userDocs = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: usernameOrEmailLower)
        .get();

    if (userDocs.docs.isNotEmpty) {
      return userDocs.docs.first.get('rol');
    }

    final emailDocs = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: usernameOrEmailLower)
        .get();

    if (emailDocs.docs.isNotEmpty) {
      return emailDocs.docs.first.get('rol');
    }

    return null;
  }
}
