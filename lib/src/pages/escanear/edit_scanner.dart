// ignore_for_file: library_private_types_in_public_api
import 'package:e_price/src/pages/productos/edit_product_page.dart';
import 'package:e_price/src/services/print_service.dart';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:e_price/src/screen.dart';

class EditScannedDataPage extends StatefulWidget {
  final dynamic userData;
  final Map<String, dynamic> productData;
  final String docId;

  const EditScannedDataPage(
      {super.key,
      required this.productData,
      required this.docId,
      required this.userData});

  @override
  _EditScannedDataPageState createState() => _EditScannedDataPageState();
}

class _EditScannedDataPageState extends State<EditScannedDataPage> {
  late TextEditingController _codigoController;
  late TextEditingController _nombreController;
  late TextEditingController _codeController;
  late TextEditingController _precioController;
  late TextEditingController _proveedorController;

  @override
  void initState() {
    super.initState();
    _codigoController =
        TextEditingController(text: widget.productData['CODIGO DE BARRAS']);
    _nombreController =
        TextEditingController(text: widget.productData['NOMBRE DEL PRODUCTO']);
    _codeController =
        TextEditingController(text: widget.productData['CODIGO DEL ARTICULO']);
    _precioController =
        TextEditingController(text: widget.productData['PRECIO']);
    _proveedorController =
        TextEditingController(text: widget.productData['userName']);
  }

  Barcode getBarcodeType(String barcode) {
    final isAllDigits = barcode.runes.every((rune) => rune >= 48 && rune <= 57);

    if (barcode.length == 12 && isAllDigits) {
      return Barcode.upcA(); // UPC-A
    } else if (barcode.length == 13 && isAllDigits) {
      return Barcode.ean13(); // EAN-13
    } else if (barcode.length > 6) {
      return Barcode.code128(); // Code 128
    } else {
      return Barcode.code39(); // Alternativa para códigos más cortos
    }
  }

  void _showPrintPreview() {
    final barcode = _codigoController.text;
    final barcodeType = getBarcodeType(barcode);
    final now = DateTime.now();
    final parsedTime = "${now.day}/${now.month}/${now.year}";
    final PrinterService printerService = PrinterService();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Vista Previa del Ticket'),
          content: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              color: Colors.grey[200],
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Transform(
                    alignment: Alignment.center,
                    //girar a 90 grados
                    transform: Matrix4.rotationZ(1.5708),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          color: Colors.redAccent,
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _nombreController.text,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                _codeController.text,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_codeController.text,
                                    style: const TextStyle(fontSize: 15)),
                                Text(parsedTime,
                                    style: const TextStyle(fontSize: 15)),
                                Text(_codigoController.text,
                                    style: const TextStyle(fontSize: 15)),
                              ],
                            ),
                            Text("\$ ${_precioController.text}",
                                style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                  BarcodeWidget(
                    barcode: barcodeType,
                    data: barcode,
                    width: 200,
                    height: 80,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Imprimir'),
              onPressed: () async {
                Navigator.of(context).pop();
                final itemName = """${_nombreController.text}""";
                //await PrinterService().print(text);
                // print(text);
                print(
                    "Data: Otros parametros: \$${widget.productData["PRECIO ENTERO"]}");
                var result = await printerService.printText(
                  itemName,
                  _codeController.text,
                  "\$${_precioController.text}",
                  "Fecha: $parsedTime",
                  "Otros parametros: \$${widget.productData["PRECIO ENTERO"]} Kg",
                );
                if (result != null) {
                  showSnackbar(context, "Error Imprimiendo: $result");
                } else {}
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pink,
        iconTheme: const IconThemeData(color: AppColors.white),
        centerTitle: true,
        title: const Text('Imprimir Etiqueta',
            style: TextStyle(
                fontFamily: "MonB", color: AppColors.white, fontSize: 20)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text("Código de Barras",
                  style: TextStyle(fontFamily: "MonB", fontSize: 20)),
              BarcodeWidget(
                barcode: getBarcodeType(widget.productData['CODIGO DE BARRAS']),
                data: widget.productData['CODIGO DE BARRAS'],
                width: 200,
                height: 80,
                color: Colors.black,
              ),
              const SizedBox(height: 20),
              InputDecorationWidget(
                controller: _proveedorController,
                labelText: 'Proveedor',
                hintText: "Introduce el nombre del proveedor",
                readOnly: true,
              ),
              const SizedBox(height: 20),
              InputDecorationWidget(
                controller: _codeController,
                labelText: 'Código del Artículo',
                hintText: "Introduce el código del artículo",
              ),
              const SizedBox(height: 20),
              InputDecorationWidget(
                controller: _codigoController,
                labelText: 'Código de Barras',
                hintText: "Introduce el código de barras",
              ),
              const SizedBox(height: 20),
              InputDecorationWidget(
                controller: _nombreController,
                labelText: 'Nombre del Producto',
                hintText: "Introduce el nombre del producto",
              ),
              const SizedBox(height: 20),
              InputDecorationWidget(
                controller: _precioController,
                labelText: 'Precio',
                hintText: "Introduce el precio del producto",
              ),
              const SizedBox(height: 20),
              MaterialButtomWidget(
                color: AppColors.orange,
                onPressed: _showPrintPreview,
                title: 'Imprimir',
              ),
              const SizedBox(height: 20),
              MaterialButtomWidget(
                color: AppColors.orange,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProductPage(
                        productData: widget.productData,
                        docId: widget.productData["idDoc"],
                        userData: widget.userData,
                      ),
                    ),
                  );
                },
                title: 'Editar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
