// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:e_price/src/pages/account/profile_page.dart';
import 'package:e_price/src/pages/escanear/scanner_page_view.dart';
import 'package:e_price/src/pages/productos/productos_page.dart';
import 'package:e_price/src/screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class InicioScreen extends StatefulWidget {
  final dynamic userData;
  const InicioScreen({super.key, this.userData});

  @override
  _InicioScreenState createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  int index = 0;
  dynamic userDatos;

  @override
  void initState() {
    super.initState();
    _getUserData();
    // Suscribirse a un topic
    FirebaseMessaging.instance.subscribeToTopic('all');
  }

  //stream para leer los datos del usuario
  void _getUserData() {
    final authProvider = Provider.of<AuthProviderP>(context, listen: false);
    final user = widget.userData['id'];
    authProvider.leerUserDataStream(user).listen((event) {
      if (mounted) {
        setState(() {
          userDatos = event.data();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userDatos == null) {
      return const ShimerWidget();
    } else {
      print("userDatos: ${userDatos}");
      final screens = [
        ScannerPageView(userDatos: userDatos),
        ProductosPage(userData: userDatos),
        Container(color: AppColors.orangeAccent),
        ProfilePage(userData: userDatos)
      ];

      return WillPopScope(
        onWillPop: () async {
          final shouldPop = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: AppColors.darkColor,
                title: const Text(
                  '¿Está seguro que desea salir de la App?',
                  style: TextStyle(
                      fontFamily: "MonB",
                      fontSize: 18,
                      color: AppColors.orangeAccent,
                      letterSpacing: 0.5),
                  textAlign: TextAlign.center,
                ),
                actions: <Widget>[
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: AppColors.orangeAccent,
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text(
                          'No',
                          style: TextStyle(
                              fontFamily: "MonB",
                              color: AppColors.white,
                              fontSize: 17),
                        ),
                      ),
                      const SizedBox(width: 20),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: AppColors.blueColors,
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          // Cerrar completamente la aplicación
                          SystemNavigator.pop();
                        },
                        child: const Text(
                          'Sí',
                          style: TextStyle(
                              fontFamily: "MonB",
                              color: AppColors.white,
                              fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              );
            },
          );
          return shouldPop ?? false;
        },
        child: Scaffold(
          extendBody: true,
          body: screens[index],
          bottomNavigationBar: Theme(
            data: Theme.of(context)
                .copyWith(iconTheme: const IconThemeData(color: Colors.white)),
            child: BottomNavigationBar(
              backgroundColor: AppColors.darkColor,
              selectedItemColor: AppColors.orange,
              unselectedItemColor: AppColors.pink,
              currentIndex: index,
              selectedLabelStyle:
                  const TextStyle(fontFamily: "MonB", fontSize: 13),
              unselectedLabelStyle:
                  const TextStyle(fontFamily: "MonB", fontSize: 13),
              onTap: (int i) {
                setState(() {
                  index = i;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopify_rounded),
                  label: 'Productos',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'Notificaciones',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Perfil',
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
