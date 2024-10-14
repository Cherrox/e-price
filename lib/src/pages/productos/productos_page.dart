import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_price/src/pages/productos/add_product_page.dart';
import 'package:e_price/src/pages/productos/edit_product_page.dart';
import 'package:e_price/src/pages/productos/product_details_page.dart';
import 'package:e_price/src/screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductosPage extends StatefulWidget {
  final dynamic userData;
  const ProductosPage({super.key, this.userData});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pink,
        title: const Text('Productos',
            style: TextStyle(color: AppColors.white, fontFamily: "PB")),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.white, size: 30),
            onPressed: () {
              //agregar datos de los productos
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddProductPage(userData: widget.userData),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                margin: const EdgeInsets.only(
                  top: 25,
                  // bottom: 15,
                ),
                child: Container(
                  child: InputDecorationWidget(
                    hintText: 'Buscar',
                    labelText: "buscar por nombre o codigo de barras",
                    controller: _searchController,
                    onChanged: (p0) => setState(() {}),
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users/${widget.userData['id']}/productos')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  print(
                      "QuerySnapshot: 'users/${widget.userData['id']}/productos'");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(child: const ShimerWidget());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No hay productos disponibles',
                            style: TextStyle(color: AppColors.black)));
                  }

                  final products = _searchController.value.text.isEmpty
                      ? snapshot.data!.docs
                      : snapshot.data!.docs
                          .where(
                            (element) =>
                                element["NOMBRE DEL PRODUCTO"]
                                    .toString()
                                    .toLowerCase()
                                    .contains(_searchController.value.text
                                        .toLowerCase()) ||
                                element["CODIGO DE BARRAS"]
                                    .toString()
                                    .toLowerCase()
                                    .contains(_searchController.value.text
                                        .toLowerCase()),
                          )
                          .toList();

                  return Expanded(
                    child: ListView.builder(
                      // physics: const BouncingScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final data = product.data() as Map<String, dynamic>;
                        final image = data['imageProduct'];

                        return Card(
                          elevation: 10,
                          margin: const EdgeInsets.all(10),
                          shadowColor: AppColors.pink,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(5),
                            minVerticalPadding: 5,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    data['NOMBRE DEL PRODUCTO'] ??
                                        'Producto sin nombre',
                                    style: const TextStyle(
                                        fontFamily: "PB", fontSize: 18)),
                                Text(
                                    'Código de barras: ${data['CODIGO DE BARRAS']}',
                                    style: const TextStyle(
                                        fontFamily: "PR", fontSize: 14)),
                              ],
                            ),
                            subtitle: Text(
                                'Precio: ${data['PRECIO'] ?? 'No disponible'}',
                                style: const TextStyle(
                                    fontFamily: "PR", fontSize: 14)),
                            onTap: () {
                              // ver los detalles del producto
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsPage(
                                    productData: data,
                                    userData: widget.userData,
                                  ),
                                ),
                              );
                            },
                            leading: image != null
                                ? CachedNetworkImage(
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                    cacheKey: image,
                                    imageUrl: image,
                                    imageBuilder: (context, imageProvider) =>
                                        ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                          width: 60,
                                          height: 60),
                                    ),
                                    placeholder: (context, url) => ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: const Image(
                                          image: AssetImage(
                                              'assets/gif/animc.gif'),
                                          fit: BoxFit.cover,
                                          width: 60,
                                          height: 60),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: const Image(
                                          image: AssetImage(
                                              'assets/images/noimage.png'),
                                          fit: BoxFit.cover,
                                          width: 60,
                                          height: 60),
                                    ),
                                  )
                                : const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: IconButton(
                                      icon: Icon(Icons.add_a_photo,
                                          color: AppColors.pink, size: 30),
                                      onPressed: null,
                                    ),
                                  ),
                            trailing: IconButton(
                                onPressed: () {
                                  //navegar a la página de edición pasar los datos del producto seleccionado
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProductPage(
                                        productData: data,
                                        docId: product.id,
                                        userData: widget.userData,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit,
                                    color: AppColors.pink)),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
