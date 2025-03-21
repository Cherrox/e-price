// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_price/src/screen.dart';
import 'package:e_price/src/utils/add_image.dart';
import 'package:e_price/src/widgets/button_decoration_widget.dart';
import 'package:e_price/src/widgets/full_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic> productData;
  final dynamic userData;
  final String docId;
  const EditProductPage({
    super.key,
    required this.productData,
    required this.docId,
    required this.userData,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  File? _image;
  bool _isLoading = false;
  String? imageData;

  late TextEditingController _codigoController;
  late TextEditingController _nombreController;
  late TextEditingController _codeController;
  late TextEditingController _precioController;
  late TextEditingController _precioEnteroController;
  late TextEditingController _precioMiembrosController;
  late TextEditingController _nUMSKUController;
  late TextEditingController _atributoController;
  late TextEditingController _listPrecioController;
  late TextEditingController _unidadController;
  late TextEditingController _nivelController;
  late TextEditingController _origenController;
  late TextEditingController _especificacionesController;

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
    _precioEnteroController =
        TextEditingController(text: widget.productData['PRECIO ENTERO']);
    _precioMiembrosController =
        TextEditingController(text: widget.productData['PRECIO PARA MIEMBROS']);
    _nUMSKUController = TextEditingController(text: widget.productData['SKU']);
    _atributoController = TextEditingController(
        text: widget.productData['ATRIBUTO DE LA PLANTILLA']);
    _listPrecioController =
        TextEditingController(text: widget.productData['LISTA DE PRECIO']);
    _unidadController =
        TextEditingController(text: widget.productData['UNIDAD']);
    _nivelController = TextEditingController(text: widget.productData['NIVEL']);
    _origenController =
        TextEditingController(text: widget.productData['ORIGEN']);
    _especificacionesController =
        TextEditingController(text: widget.productData['ESPECIFICACIONES']);
    imageData = widget.productData['imageProduct'];
  }

  bool _hasDataChanged() {
    return _codigoController.text != widget.productData['CODIGO DE BARRAS'] ||
        _nombreController.text != widget.productData['NOMBRE DEL PRODUCTO'] ||
        _codeController.text != widget.productData['CODIGO DEL ARTICULO'] ||
        _precioController.text != widget.productData['PRECIO'] ||
        _precioEnteroController.text != widget.productData['PRECIO ENTERO'] ||
        _precioMiembrosController.text !=
            widget.productData['PRECIO PARA MIEMBROS'] ||
        _nUMSKUController.text != widget.productData['SKU'] ||
        _atributoController.text !=
            widget.productData['ATRIBUTO DE LA PLANTILLA'] ||
        _listPrecioController.text != widget.productData['LISTA DE PRECIO'] ||
        _unidadController.text != widget.productData['UNIDAD'] ||
        _nivelController.text != widget.productData['NIVEL'] ||
        _origenController.text != widget.productData['ORIGEN'] ||
        _especificacionesController.text !=
            widget.productData['ESPECIFICACIONES'] ||
        _image != null;
  }

  Future<void> _uploadImage() async {
    if (!_hasDataChanged()) {
      showSnackbar(context, 'Nada que editar');
      return;
    }

    final authProvider = Provider.of<AuthProviderP>(context, listen: false);
    final firestore = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;

    String imageNewUrl = "";
    String? oldImageUrl = widget.productData['imageProduct'];

    setState(() {
      _isLoading = true;
    });

    if (_image != null) {
      final time = Timestamp.now().millisecondsSinceEpoch.toString();
      final refCollection = 'productos/${widget.docId}/imageProduct$time.png';
      imageNewUrl = await authProvider.storeFileStorage(refCollection, _image!);

      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        final oldImageRef = storage.refFromURL(oldImageUrl);
        await oldImageRef.delete();
      }
    } else {
      imageNewUrl = oldImageUrl ?? "";
    }

    await firestore
        .collection("users/${widget.userData['id']}/productos")
        .doc(widget.docId)
        .update({
      'imageProduct': imageNewUrl,
      'CODIGO DE BARRAS': _codigoController.text,
      'NOMBRE DEL PRODUCTO': _nombreController.text,
      'CODIGO DEL ARTICULO': _codeController.text,
      'PRECIO': _precioController.text,
      'PRECIO ENTERO': _precioEnteroController.text,
      'PRECIO PARA MIEMBROS': _precioMiembrosController.text,
      'SKU': _nUMSKUController.text,
      'ATRIBUTO DE LA PLANTILLA': _atributoController.text,
      'LISTA DE PRECIO': _listPrecioController.text,
      'UNIDAD': _unidadController.text,
      'NIVEL': _nivelController.text,
      'ORIGEN': _origenController.text,
      'ESPECIFICACIONES': _especificacionesController.text,
    });

    Navigator.pop(context, true);
    showSnackbar(context, 'Producto actualizado correctamente');
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 350.0,
            pinned: true,
            centerTitle: true,
            backgroundColor: AppColors.pink,
            title: const Text('Editar producto',
                style: TextStyle(color: AppColors.white, fontFamily: "PB")),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_a_photo,
                    color: AppColors.white, size: 30),
                onPressed: () {
                  showImageSourceDialog(context, (image) {
                    setState(() {
                      _image = image;
                      imageData = null; // Clear the old image URL
                    });
                  });
                },
              ),
            ],
            iconTheme: const IconThemeData(color: AppColors.white),
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // Cambia el color del texto basado en la posición del scroll
                //final double appBarHeight = constraints.biggest.height;
                //final bool isCollapsed = appBarHeight <= kToolbarHeight + MediaQuery.of(context).padding.top;
                //final Color titleColor = isCollapsed ? AppColors.white : AppColors.black;
                // final double fontSize = isCollapsed ? 17.0 : 14.0;

                return FlexibleSpaceBar(
                  centerTitle: true,
                  // title: Text(
                  //   widget.productData['NOMBRE DEL PRODUCTO'],
                  //   style: TextStyle(color: titleColor, fontSize: fontSize),
                  // ),
                  background: _image != null
                      ? Image.file(
                          _image!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : (imageData != null && imageData!.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FullScreen(imageData!),
                                  ),
                                );
                              },
                              child: Hero(
                                tag: imageData!,
                                child: CachedNetworkImage(
                                  imageUrl: imageData!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Image(
                                    image: AssetImage('assets/gif/animc.png'),
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Image(
                                    image:
                                        AssetImage('assets/images/noimage.png'),
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                              ),
                            )
                          : const Image(
                              image: AssetImage('assets/images/noimage.png'),
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            )),
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      InputDecorationWidget(
                        hintText: 'Nombre del producto',
                        labelText: "Nombre del producto",
                        controller: _nombreController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese el nombre del producto';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputDecorationWidget(
                        hintText: 'Código de barras',
                        labelText: "Código de barras",
                        controller: _codigoController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese el código de barras';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputDecorationWidget(
                        hintText: 'Código del artículo',
                        labelText: "Código del artículo",
                        controller: _codeController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese el código del artículo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputDecorationWidget(
                        hintText: 'Precio',
                        labelText: "Precio",
                        controller: _precioController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese el precio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputDecorationWidget(
                        hintText: 'Precio entero',
                        labelText: "Precio entero",
                        controller: _precioEnteroController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese el precio entero';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputDecorationWidget(
                        hintText: 'Precio para miembros',
                        labelText: "Precio para miembros",
                        controller: _precioMiembrosController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese el precio para miembros';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputDecorationWidget(
                        hintText: 'NUM.SKU',
                        labelText: "NUM.SKU",
                        controller: _nUMSKUController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese el NUM.SKU';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputDecorationWidget(
                        hintText: 'Atributo de la plantilla',
                        labelText: "Atributo de la plantilla",
                        controller: _atributoController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese el atributo de la plantilla';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputDecorationWidget(
                        hintText: 'Lista de precio',
                        labelText: "Lista de precio",
                        controller: _listPrecioController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese la lista de precio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputDecorationWidget(
                        hintText: 'Unidad',
                        labelText: "Unidad",
                        controller: _unidadController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese la unidad';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputDecorationWidget(
                        hintText: 'Nivel',
                        labelText: "Nivel",
                        controller: _nivelController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese el nivel';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputDecorationWidget(
                        hintText: 'Origen',
                        labelText: "Origen",
                        controller: _origenController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese el origen';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputDecorationWidget(
                        hintText: 'Especificaciones',
                        labelText: "Especificaciones",
                        controller: _especificacionesController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese las especificaciones';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                );
              },
              childCount: 1,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40, top: 20),
              child: _isLoading
                  ? const CircularProgressWidget(
                      text: "Actualizando...", color: AppColors.orange)
                  : ButtonDecorationWidget(
                      onPressed: _uploadImage,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      text: "ACTUALIZAR",
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
