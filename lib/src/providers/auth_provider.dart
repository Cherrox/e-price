// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_price/src/screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus { notAuthenticated, checking, authenticated }

enum UserRole { admin, manager, user }

class AuthProviderP extends ChangeNotifier {
  AuthStatus authStatus = AuthStatus.notAuthenticated;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyR = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyRP = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> notifyFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController emailOrUsernamecontroller =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController tituloNotify = TextEditingController();
  final TextEditingController descriptionNotify = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // set isLoading(bool value) {
  //   _isLoading = value;
  //   notifyListeners();
  // }

  void getLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _isLoginGoogle = false;
  bool get isLoginGoogle => _isLoginGoogle;

  set isLoginGoogle(bool value) {
    _isLoginGoogle = value;
    notifyListeners();
  }

  String? _errorMessage;
  String get errorMessage => _errorMessage ?? '';

  set errorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  bool _obscureText = true;
  bool get obscureText => _obscureText;

  set obscureText(bool value) {
    _obscureText = value;
    notifyListeners();
  }

  bool isLoggedIn = false;
  bool get isLogged => isLoggedIn;

  set isLogged(bool value) {
    isLoggedIn = value;
    notifyListeners();
  }

  //stream para leer los datos del usuario especifico
  Stream<DocumentSnapshot> leerUserDataStream(String userId) {
    return firestore.collection('users').doc(userId).snapshots();
  }

//INICIAR SESIÓN
  Future<void> signInWithGoogle(BuildContext context, String? token) async {
    isLoginGoogle = true;
    notifyListeners();
    //cerrar teclado
    FocusScope.of(context).unfocus();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        // Obtener los datos del usuario desde la base de datos
        dynamic userData = await getUserData(googleSignInAccount.email);

        if (userData == null) {
          // No se encontró ningún usuario con el correo electrónico proporcionado.
          showSnackbar(context, "Correo no registrado");
          await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
          isLoginGoogle = false;
          notifyListeners();
          return;
        } else {
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );
          final UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          final User? user = userCredential.user;

          if (user != null) {
            // Obtener el token del dispositivo
            //token = PushNotificationService.token;
            String idUser = userData['id'].toString();
            // Actualizar el token del usuario
            await FirebaseFirestore.instance
                .collection('users')
                .doc(idUser)
                .update({'token': token});

            showSnackbar(context, "Bienvenido ${userData['username']}");

            // Cambiar el estado de la autenticación
            checkAuthStatus();
            // Navegar a la página de inicio
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => InicioScreen(
                    userData: userData,
                  ),
                ));
            //fin de proceso
            isLoginGoogle = false;
            notifyListeners();
          }
        }
      }
    } catch (e) {
      //print("Error al iniciar sesión con Google: $e");
      showSnackbar(context, "Error al iniciar sesión con Google");
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      isLoginGoogle = false;
      notifyListeners();
    } finally {
      isLoginGoogle = false;
      notifyListeners();
    }
  }

  //REGISTRAR USUARIO
  Future<User?> registerWithGoogle(BuildContext context, String? token) async {
    isLoginGoogle = true;
    notifyListeners();
    //cerrar teclado
    FocusScope.of(context).unfocus();

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      isLoginGoogle = false;
      notifyListeners();
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = authResult.user;

    if (user != null) {
      // Obtener la fecha y hora actual
      DateTime now = DateTime.now();

      //obtener la referencia a la coleccion de usuarios
      final userRef = FirebaseFirestore.instance.collection('users');

      //guardar datos
      final userData = {
        'id': user.uid,
        'username': googleUser.displayName,
        'username_lowercase':
            googleUser.displayName!.toLowerCase().replaceAll(' ', ''),
        'email': googleUser.email.toLowerCase(),
        'password': '',
        'birth': '',
        'nameAndApellido': '',
        'sexo': "",
        'direccion': "",
        'imageUser': googleUser.photoUrl!,
        'telefono': "",
        'biografia': "Soy ${googleUser.displayName}",
        'createdAt': now,
        'edad': '',
        'token': token,
        'estado': 'offline',
        'premium': false,
        'aprobado': false,
        'verificado': false,
        'service': false,
        'proveedor': false,
        'favoritos': 0,
        'compartidos': 0,
        'seguidos': 0,
        'seguidores': 0,
        'favoritosJson': [],
        'compartidosJson': [],
        'seguidosJson': [],
        'seguidoresJson': [],
        'rol': 'user',
      };

      // Aquí puedes guardar los datos del usuario en Firestore
      await userRef.doc(user.uid).set(userData);

      // Cambiar el estado de la autenticación
      checkAuthStatus();
      //navegar a la página de inicio
      // Navegar a la página de inicio
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InicioScreen(
              userData: userData,
            ),
          ));
      //fin de proceso
      isLoginGoogle = false;
      notifyListeners();
    }

    return user;
  }

  //PARA OBTENER LOS DATOS DEL USUARIO
  Future<dynamic> getUserData(String email) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final userData = snapshot.docs[0].data();
      return userData;
    }

    return null;
  }

// CAMBIAR EL ESTADO DE LA AUTENTICACIÓN
  Future<void> checkAuthStatus() async {
    authStatus = AuthStatus.checking;
    notifyListeners();

    final User? user = auth.currentUser;

    if (user != null) {
      // Obtener los datos del usuario desde la base de datos
      dynamic userData = await getUserData(user.email!);

      if (userData != null) {
        authStatus = AuthStatus.authenticated;
        isLoggedIn = true;
        notifyListeners();
      } else {
        authStatus = AuthStatus.notAuthenticated;
        isLoggedIn = false;
        notifyListeners();
      }
    } else {
      authStatus = AuthStatus.notAuthenticated;
      isLoggedIn = false;
      notifyListeners();
    }
  }

//VERIFICA SI EL EMAIL YA SE ENCUENTRA EN LA BASE DE DATOS
  Future<bool> checkEmailExists(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email.toLowerCase())
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  //SALIR DE LA APP
  Future<void> logoutApp() async {
    await auth.signOut();
    authStatus = AuthStatus.notAuthenticated;
    isLoggedIn = false;
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    // Elimina la clave 'is_signedin' de la caja
    if (LocalStorage.box.containsKey('is_signedin')) {
      LocalStorage.box.delete('is_signedin');
    }
  }

  //editar perfil
  Future<void> editarPerfil({
    required File? image,
    required dynamic userData,
    required String username,
    required BuildContext context,
  }) async {
    try {
      // Verificar si el formulario es válido
      if (!formKeyEdit.currentState!.validate()) {
        // Mostrar mensaje de error si el formulario no es válido
        showSnackbar(
            context, "Por favor, complete el formulario correctamente.");
        return;
      }

      // Verificar si hay cambios en el nombre de usuario
      bool usernameChanged = usernameController.text != userData['username'];

      // Verificar si hay cambios en la imagen
      bool imageChanged = image != null;

      // Verificar si hay cambios
      if (!usernameChanged && !imageChanged) {
        // Mostrar mensaje de que no hay cambios para actualizar
        showSnackbar(context, "No hay cambios para actualizar.");
        return;
      }

      // Iniciar la animación y mostrar Snackbar de actualización
      getLoading(true);
      await Future.delayed(
          const Duration(milliseconds: 500)); // Simula la animación

      //cerrar teclado
      FocusScope.of(context).unfocus();

      String idUser = userData['id'].toString();

      // Obtener la fecha y hora actual
      DateTime now = DateTime.now();

      // ref a la colección de usuarios
      final userRef = FirebaseFirestore.instance.collection('users');

      String imageUrl = '';
      if (image != null) {
        // Construir el nuevo nombre de la imagen usando el ID del usuario
        String newImageName = 'users/$username/$idUser.jpg';
        // Guardar la imagen con el nuevo nombre
        imageUrl = await storeFileStorage(newImageName, image);
      }

      // Actualizar los datos del usuario en Firestore
      await userRef.doc(idUser).update({
        'username': username,
        'username_lowercase': username.toLowerCase(),
        'imageUser': imageUrl.isNotEmpty ? imageUrl : userData['imageUser'],
        'updatedAt': now,
      });

      // Mostrar mensaje de éxito
      showSnackbar(context, "Perfil actualizado correctamente");
      getLoading(false);
      // Navegar de vuelta o refrescar la UI
      Navigator.of(context).pop();
    } catch (e) {
      showSnackbar(context, 'Ha ocurrido un error durante la actualización');
      getLoading(false);
    }
  }

  //recuperar password

  Future<void> recoveryPassWord(
    String emailLower,
    BuildContext context,
  ) async {
    if (!formKeyRP.currentState!.validate()) return;
    getLoading(true);
    //cerrar el teclado
    FocusScope.of(context).unfocus();

    final users = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: emailLower.toLowerCase())
        .get();

    //buscar el email en firebase auth
    User? user = FirebaseAuth.instance.currentUser;

    if (users.docs.isEmpty && user == null) {
      // Si no hay usuarios con este correo electrónico, muestra un mensaje de error
      showSnackbar(context, 'No existe una cuenta con este correo electrónico');
    } else {
      try {
        // Envía correo desde firebase
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailLower);

        //limpiar el campo de texto
        emailController.clear();
        //cambiar el estado de isLoading a false
        getLoading(false);

        dialogoDeConfirmacion(
          context,
          "Email enviado",
          "Se ha enviado un correo a ${emailController.text}. Por favor, haz clic en el enlace de verificación para cambiar tu contraseña.",
        );
      } catch (e) {
        showSnackbar(context, e.toString());
        getLoading(false);
      }
    }
  }

  //enviar notificaciones

  //enviar notificaciones
  Future<void> submitNotification(
    String titulo,
    String description,
    File? image,
    dynamic userData,
    BuildContext context,
  ) async {
    getLoading(true);
    final idUser = userData['id'].toString();
    final username = userData['username'];

    //cerrar teclado
    FocusScope.of(context).unfocus();
    //validar formulario
    if (!notifyFormKey.currentState!.validate()) {
      getLoading(false);
      return;
    }

    //ref a la colección de notificaciones
    final refNotify = firestore.collection('notifications');
    //id unico del documento
    final idNotify = refNotify.doc().id;

    String imageUrl = '';
    if (image != null) {
      // Construir el nuevo nombre de la imagen usando el ID del usuario
      String newImageName = 'notificaciones/$username/$idUser.jpg';

      // Guardar la imagen con el nuevo nombre
      imageUrl = await storeFileStorage(newImageName, image);
    }

    try {
      //guardar datos en firestore
      await refNotify.doc(idNotify).set({
        'id': idNotify,
        'titulo': titulo,
        'description': description,
        'createdAt': DateTime.now(),
        'username': username,
        'id_usuario': idUser,
        'imageUser': userData['imageUser'].toString(),
        'imageNotify': imageUrl,
      });

      //notificar al usuario que sube
      showSnackbar(context, "Se envio la notificación correctamente");
      getLoading(false);
      //imprime datos en la consola
      //print("Datos $datos");

      //notificacion a todos los usuarios con firebase
      PushNotificationService notificationManager = PushNotificationService();
      notificationManager.sendNotificationToAllUsers(
        titulo,
        description,
        imageUrl.isNotEmpty ? imageUrl : null,
      );
      //print("notificationManager $notificationManager");
      //navegar atras y limpiar los campos
      Navigator.of(context).pop();
      tituloNotify.clear();
      descriptionNotify.clear();
    } catch (e) {
      showSnackbar(context, 'Ha ocurrido un error durante el envio');
      getLoading(false);
    }
  }

  //SAVE IMAGE
  Future<String> storeFileStorage(String ref, File file) async {
    UploadTask uploadTask = _storage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
