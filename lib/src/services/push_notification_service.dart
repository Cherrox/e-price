import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_price/firebase_options.dart';
import 'package:e_price/src/screen.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final pushNotificationService = PushNotificationService();

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static String? token;
  static final StreamController<String> _messageStreamController =
      StreamController.broadcast();
  static Stream<String> get messageStream => _messageStreamController.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    _messageStreamController
        .add(message.notification?.title ?? "No hay titulo");
    final data = message.data;
    final title = data['title'];
    final body = data['body'];
    final imageUrl = data['image'];
    final userToken = data['token'];

    if (title != null && body != null) {
      await mostrarNotificacion(title, body, imageUrl);
    }

    if (userToken != null) {
      await pushNotificationService.sendNotificationToAllUsers(
          title, body, imageUrl);
    }
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    _messageStreamController
        .add(message.notification?.title ?? "No hay titulo");
    final data = message.data;
    final title = data['title'];
    final body = data['body'];
    final imageUrl = data['image'];
    final userToken = data['token'];

    if (title != null && body != null) {
      await mostrarNotificacion(title, body, imageUrl);
    }

    if (userToken != null) {
      await pushNotificationService.sendNotificationToAllUsers(
          title, body, imageUrl);
    }
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    _messageStreamController
        .add(message.notification?.title ?? "No hay titulo");
  }

  static Future initializeApp() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await initNotification();
    messaging.requestPermission();
    token = await FirebaseMessaging.instance.getToken();

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  Future<void> sendNotificationToAllUsers(
      String title, String body, String? imageUrl) async {
    // const serviceAccountPath = 'assets/e-price-13564-5c0a4f0ec8a7.json';
    // final accountCredentials = ServiceAccountCredentials.fromJson(
    //     json.decode(await rootBundle.loadString(serviceAccountPath)));

    // final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    // final client = await clientViaServiceAccount(accountCredentials, scopes);

    // const String fcmUrl =
    //     'https://fcm.googleapis.com/v1/projects/e-price-13564/messages:send';

    // final mensaje = {
    //   "message": {
    //     "topic": "all",
    //     "notification": {
    //       "title": title,
    //       "body": body,
    //     },
    //     "data": {
    //       "title": title,
    //       "body": body,
    //       "click_action": "FLUTTER_NOTIFICATION_CLICK",
    //     }
    //   }
    // };

    // if (imageUrl != null) {
    //   mensaje['message']?['data'] ??= {};
    //   (mensaje['message']?['data'] as Map<String, dynamic>)['image'] = imageUrl;
    // }

    // final response = await client.post(
    //   Uri.parse(fcmUrl),
    //   headers: {
    //     'Content-Type': 'application/json',
    //   },
    //   body: jsonEncode(mensaje),
    // );

    // if (response.statusCode == 200) {
    //   //print("Notificación enviada exitosamente");
    // } else {
    //   //print("Error al enviar la notificación: ${response.body}");
    // }
  }

  //notificar a un usuario especifico
  Future<void> sendNotificationToUser(
      String userToken, String title, String body, String? imageUrl) async {
    // const serviceAccountPath = 'assets/e-price-13564-5c0a4f0ec8a7.json';
    // final accountCredentials = ServiceAccountCredentials.fromJson(
    //     json.decode(await rootBundle.loadString(serviceAccountPath)));

    // final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    // final client = await clientViaServiceAccount(accountCredentials, scopes);

    // const String fcmUrl =
    //     'https://fcm.googleapis.com/v1/projects/e-price-13564/messages:send';

    // final mensaje = {
    //   "message": {
    //     "token": userToken,
    //     "notification": {
    //       "title": title,
    //       "body": body,
    //     },
    //     "data": {
    //       "title": title,
    //       "body": body,
    //       "click_action": "FLUTTER_NOTIFICATION_CLICK",
    //     }
    //   }
    // };

    // if (imageUrl != null) {
    //   mensaje['message']?['data'] ??= {};
    //   (mensaje['message']?['data'] as Map<String, dynamic>)['image'] = imageUrl;
    // }

    // final response = await client.post(
    //   Uri.parse(fcmUrl),
    //   headers: {
    //     'Content-Type': 'application/json',
    //   },
    //   body: jsonEncode(mensaje),
    // );

    // if (response.statusCode == 200) {
    //   //print("Notificación enviada exitosamente");
    // } else {
    //   //print("Error al enviar la notificación: ${response.body}");
    // }
  }

  Future<void> sendNotificationToAdminUsers(
      String title, String body, String? imageUrl) async {
    // const serviceAccountPath = 'assets/e-price-13564-5c0a4f0ec8a7.json';
    // final accountCredentials = ServiceAccountCredentials.fromJson(
    //     json.decode(await rootBundle.loadString(serviceAccountPath)));

    // final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    // final client = await clientViaServiceAccount(accountCredentials, scopes);

    // const String fcmUrl =
    //     'https://fcm.googleapis.com/v1/projects/e-price-13564/messages:send';

    // final QuerySnapshot<Map<String, dynamic>> adminUsersSnapshot =
    //     await FirebaseFirestore.instance
    //         .collection('users')
    //         .where('rol', isEqualTo: 'admin')
    //         .get();

    // final List<String> adminTokens = [];

    // for (var userDoc in adminUsersSnapshot.docs) {
    //   final String token = userDoc.data()['token'] as String;
    //   adminTokens.add(token);
    // }

    // final mensaje = {
    //   "message": {
    //     "tokens": adminTokens, // Aquí usamos los tokens de los administradores
    //     "notification": {
    //       "title": title,
    //       "body": body,
    //     },
    //     "data": {
    //       "title": title,
    //       "body": body,
    //       "click_action": "FLUTTER_NOTIFICATION_CLICK",
    //     }
    //   }
    // };

    // if (imageUrl != null) {
    //   mensaje['message']?['data'] ??= {};
    //   (mensaje['message']?['data'] as Map<String, dynamic>)['image'] = imageUrl;
    // }

    // final response = await client.post(
    //   Uri.parse(fcmUrl),
    //   headers: {
    //     'Content-Type': 'application/json',
    //   },
    //   body: jsonEncode(mensaje),
    // );

    // if (response.statusCode == 200) {
    //   // print("Notificación enviada exitosamente a los administradores");
    // } else {
    //   // print("Error al enviar la notificación: ${response.body}");
    // }
  }

  static closeStream() {
    _messageStreamController.close();
  }
}
