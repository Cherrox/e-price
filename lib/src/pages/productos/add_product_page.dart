// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:async';
import 'package:e_price/src/pages/productos/add_one_product_page%20copy.dart';
import 'package:e_price/src/screen.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class AddProductPage extends StatefulWidget {
  final dynamic userData;
  const AddProductPage({super.key, this.userData});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  bool isLoading = false;
  final StreamController<int> _progressController = StreamController<int>();

  @override
  void dispose() {
    _progressController.close();
    super.dispose();
  }

  Future<void> _uploadExcelData(String filePath) async {
    setState(() {
      isLoading = true;
    });

    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      var excel = Excel.decodeBytes(bytes);

      final refCollection = FirebaseFirestore.instance
          .collection('users/${widget.userData['id']}/productos');
      int totalRows = 0;
      int processedRows = 0;

      // Calcular el total de filas a procesar
      for (var table in excel.tables.keys) {
        totalRows += excel.tables[table]!.rows.length -
            1; // -1 para excluir la fila de encabezado
      }

      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows.skip(1)) {
          String productCode = row[0]?.value?.toString() ?? "";
          // print("productCode: ${productCode}");

          // Crear un mapa para cada producto
          Map<String, dynamic> productData = {
            'userId': widget.userData['id'].toString(),
            'userName': widget.userData['username'].toString(),
            'createdAt': DateTime.now(),
            'CODIGO DEL ARTICULO': productCode.split(".")[0],
            'CODIGO DE BARRAS': row[1]?.value?.toString().split(".")[0] ?? "",
            'SKU': row[2]?.value?.toString() ?? '',
            'NOMBRE DEL PRODUCTO': row[3]?.value?.toString() ?? '',
            'PRECIO ENTERO': row[4]?.value?.toString() ?? "",
            'PRECIO': row[5]?.value?.toString() ?? "",
            'PRECIO PARA MIEMBROS': row[6]?.value?.toString() ?? "",
            'ATRIBUTO DE LA PLANTILLA': row[7]?.value?.toString() ?? '',
            'LISTA DE PRECIO': row[8]?.value?.toString() ?? '',
            'UNIDAD': row[9]?.value?.toString() ?? '',
            'NIVEL': row[10]?.value?.toString() ?? "",
            'ORIGEN': row[11]?.value?.toString() ?? '',
            'ESPECIFICACIONES': row[12]?.value?.toString() ?? '',
            "imageProduct": "",
          };

          // Verificar si el producto ya existe
          // QuerySnapshot query = await refCollection
          //     .where('CODIGO DEL ARTICULO', isEqualTo: productCode)
          //     .get();
          // print("Query: ${query.docs}");
          // if (query.docs.isNotEmpty) {
          //   // Producto existe, verificar propiedad
          //   DocumentSnapshot doc = query.docs.first;
          //   String docId = doc.id;
          //   productData['imageProduct'] = doc['imageProduct'] ?? '';
          //   await refCollection.doc(docId).update(productData);
          // } else {
          //   // Producto no existe, agregar uno nuevo
          //   productData['idDoc'] = refCollection.doc().id;
          //   productData['imageProduct'] = '';
          //   await refCollection.doc(productData['idDoc']).set(productData);
          // }

          await refCollection.doc(productCode).set(productData);

          // Actualizar progreso
          processedRows++;
          int progressPercentage = ((processedRows / totalRows) * 100).ceil();
          _progressController.add(progressPercentage);
        }
      }

      showSnackbar(context, 'Productos subidos correctamente');
      Navigator.pop(context, true);
    } catch (e) {
      showSnackbar(context, 'Error al subir los productos');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
    if (result != null) {
      String filePath = result.files.single.path!;
      await _uploadExcelData(filePath);
    } else {
      showSnackbar(context, 'No se seleccionó ningún archivo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pink,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.white),
        title: const Text('Agregar Productos',
            style:
                TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? StreamBuilder<int>(
                      stream: _progressController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressWidget(
                                text: "Cargando\nPor favor espere....",
                                color: AppColors.orange,
                              ),
                              const SizedBox(height: 20),
                              Text('${snapshot.data}%',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          );
                        } else {
                          return const CircularProgressWidget(
                              text: "Cargando\nPor favor espere....",
                              color: AppColors.orange);
                        }
                      },
                    )
                  : MaterialButtomWidget(
                      color: AppColors.orange,
                      icon: Icons.onetwothree,
                      onPressed: _pickFile,
                      title: 'Subir productos',
                    ),
              const SizedBox(height: 20),
              MaterialButtomWidget(
                color: AppColors.orange,
                icon: Icons.plus_one,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddOneProductPage(
                        userData: widget.userData,
                      ),
                    ),
                  );
                },
                title: 'Subir producto',
              ),
            ],
          )),
    );
  }
}
