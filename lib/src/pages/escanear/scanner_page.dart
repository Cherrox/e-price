import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_price/src/pages/escanear/edit_scanner.dart';
import 'package:e_price/src/pages/productos/add_one_product_page%20copy.dart';
import 'package:e_price/src/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key, required this.userDatos});
  final dynamic userDatos;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  var focusNode = FocusNode();
  TextEditingController _barCodeController = TextEditingController();
  OutlineInputBorder _textFormFieldBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(
        width: 8,
        color: Colors.black87,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
    );
  }

  Future<void> scanBarCode() async {
    // final scanResult = await FlutterBarcodeScanner.scanBarcode(
    //   '#FFA500',
    //   'Cancelar',
    //   true,
    //   ScanMode.BARCODE,
    // );

    if (_barCodeController.value.text != '-1') {
      final query = await FirebaseFirestore.instance
          .collection('users/${widget.userDatos['id']}/productos')
          .where('CODIGO DE BARRAS', isEqualTo: _barCodeController.value.text)
          .get();

      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        // if (doc['userId'] == widget.userDatos['id'].toString()) {
        final modifiedData = await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EditScannedDataPage(
              productData: doc.data(),
              docId: doc.id,
              userData: widget.userDatos,
            ),
          ),
        );

        if (modifiedData != null) {
          setState(() {});
        }
        // } else {
        //   showSnackbar(
        //       context, 'Usted no es el propietario de estos productos');
        // }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            title: const Text(
              'Confirmar',
              textAlign: TextAlign.center,
            ),
            content: const Text(
                'El producto no existe o fue eliminado ¿Desea de agregar el producto?'),
            actions: [
              TextButton(
                child: Text("Si"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => AddOneProductPage(
                        userData: widget.userDatos,
                        barCode: _barCodeController.value.text,
                      ),
                    ),
                  );
                },
              ),
              TextButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
        // showSnackbar(context, 'El producto no existe o fue eliminado');
      }
    }
  }

  @override
  void initState() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 50)).then(
          (value) {
            //SystemChannels.textInput.invokeMethod('TextInput.hide');
          },
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _barCodeController.dispose();
    focusNode.dispose();
    // SystemChannels.textInput.invokeMethod('TextInput.show');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Future.delayed(Duration(milliseconds: 50)).then(
      (value) {
        //SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    focusNode.requestFocus();
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text(
                    "ESCANEAR CODIGO DE BARRA",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "MonB",
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 35),
                  width: size.width * 0.65,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: AppColors.orange,
                      width: 5,
                    ),
                  ),
                  child: TextFormField(
                    controller: _barCodeController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      border: _textFormFieldBorder(),
                      enabledBorder: _textFormFieldBorder(),
                      focusedBorder: _textFormFieldBorder(),
                      fillColor: Colors.transparent,
                    ),
                    onEditingComplete: scanBarCode,
                    cursorColor: Colors.white,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
