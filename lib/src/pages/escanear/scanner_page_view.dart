// ignore_for_file: library_private_types_in_public_api, library_prefixes, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hardware_buttons_find_flutter/hardware_buttons_find_flutter_method_channel.dart' as HardwareButtons;
import 'package:e_price/src/pages/escanear/edit_scanner.dart';
import 'package:e_price/src/pages/productos/add_product_page.dart';
import 'package:e_price/src/widgets/button_decoration_widget.dart';
import 'package:e_price/src/screen.dart';

class ScannerPageView extends StatefulWidget {
  final dynamic userDatos;
  const ScannerPageView({super.key, this.userDatos});

  @override
  _ScannerPageViewState createState() => _ScannerPageViewState();
}

class _ScannerPageViewState extends State<ScannerPageView> {
  StreamSubscription<String>? _buttonSubscription;

  @override
  void initState() {
    super.initState();
    _buttonSubscription = HardwareButtons.buttonEvents?.listen((event) {
      if (event == 'button1' || event == 'button2') {
        _scanBarCode();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _buttonSubscription?.cancel();
  }

  Future<void> _scanBarCode() async {
    try {
      final scanResult = await FlutterBarcodeScanner.scanBarcode(
        '#FFA500',
        'Cancelar',
        true,
        ScanMode.BARCODE,
      );
      if (scanResult != '-1') {
        final query = await FirebaseFirestore.instance
            .collection('productos')
            .where('CODIGO DE BARRAS', isEqualTo: scanResult)
            .get();

        if (query.docs.isNotEmpty) {
          final doc = query.docs.first;
          if (doc['userId'] == widget.userDatos['id'].toString()) {
            final modifiedData = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditScannedDataPage(productData: doc.data(), docId: doc.id),
              ),
            );

            if (modifiedData != null) {
              setState(() {});
            }
          } else {
            showSnackbar(context, 'Usted no es el propietario de estos productos');
          }
        } else {
          showSnackbar(context, 'El producto no existe o fue eliminado');
        }
      }
    } on PlatformException {
      setState(() {
        showSnackbar(context, "Error al escanear el código de barras");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          Image.asset("assets/icons/logob.png", height: 300),
          const SizedBox(height: 15),
          Expanded(
            child: Container(),
          ),
          const SizedBox(height: 20),
          ButtonDecorationWidget(
            icon2: const Icon(Icons.shopping_bag_rounded, color: AppColors.pink, size: 35),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProductPage(userData: widget.userDatos),
                ),
              );
            },
            margin: const EdgeInsets.symmetric(horizontal: 40),
            text: "Agregar Producto",
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Center(
              child: Text(
                "Presiona el botón para escanear\nel código de barras",
                style: TextStyle(fontSize: 15, fontFamily: "PR", color: AppColors.orange),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ButtonDecorationWidget(
            icon2: Image.asset("assets/images/barcode.png",
                color: AppColors.pink, height: 35, width: 35),
            onPressed: _scanBarCode,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            text: "ESCANEAR",
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Text("V.1.0.0", style: estiloDeTexto(14)),
              const SizedBox(height: 5),
              Text("© Zenith Agency", style: estiloDeTexto(13)),
              const SizedBox(height: 10),
            ],
          ),
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  TextStyle estiloDeTexto(double? fontSize) {
    return TextStyle(fontSize: fontSize, fontFamily: "MonB", color: AppColors.black);
  }

}
