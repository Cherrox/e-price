import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_price/src/screen.dart';
import 'package:e_price/src/widgets/full_screen.dart';
import 'package:e_price/src/widgets/ricth_text_widget.dart';
import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> productData;
  const ProductDetailsPage({super.key, required this.productData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350.0,
            pinned: true,
            centerTitle: true,
            backgroundColor: AppColors.pink,
            iconTheme: const IconThemeData(color: AppColors.white),
             flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              // Cambia el color del texto basado en la posición del scroll
              final double appBarHeight = constraints.biggest.height;
              final bool isCollapsed = appBarHeight <= kToolbarHeight + MediaQuery.of(context).padding.top;
              final Color titleColor = isCollapsed ? AppColors.white : AppColors.black;
              final double fontSize = isCollapsed ? 17.0 : 14.0;

              return FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  productData['NOMBRE DEL PRODUCTO'],
                  style: TextStyle(color: titleColor, fontSize: fontSize),
                ),
                background: productData['imageProduct'] != null
                    ? InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreen(productData['imageProduct']),
                          ),
                        );
                      },
                      child: Hero(
                        tag: productData['imageProduct'],
                        child: CachedNetworkImage(
                            imageUrl: productData['imageProduct'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Image(
                              image: AssetImage('assets/gif/animc.png'),
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            ),
                            errorWidget: (context, url, error) => const Image(
                              image: AssetImage('assets/images/noimage.png'),
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
                      ),
              );
            },
          ),
        ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 20),
                 //NOMBRE DEL PRODUCTO
                WidgetRichText(
                  text: 'Nombre del producto:  ',
                  text2: productData['NOMBRE DEL PRODUCTO'],
                  text3: '',
                  textAlign: TextAlign.start,
                ),
                 //CODIGO DEL ARTICULO
                WidgetRichText(
                  text: 'Código del artículo:  ',
                  text2: productData['CODIGO DEL ARTICULO'],
                  text3: '',
                  textAlign: TextAlign.start,
                ),
                WidgetRichText(
                  text: 'Código de barras:  ',
                  text2: productData['CODIGO DE BARRAS'],
                  text3: '',
                  textAlign: TextAlign.start,
                ),
                //NUM.SKU
                WidgetRichText(
                  text: 'Num. SKU:  ',
                  text2: productData['NUM.SKU'],
                  text3: '',
                  textAlign: TextAlign.start,
                ),
                WidgetRichText(
                  text: 'Precio:  ',
                  text2: '\$ ${productData['PRECIO']}',
                  text3: '',
                  textAlign: TextAlign.start,
                ),
                //PRECIO ENTERO
                WidgetRichText(
                  text: 'Precio entero:  ',
                  text2: '\$ ${productData['PRECIO ENTERO']}',
                  text3: '',
                  textAlign: TextAlign.start,
                ),
                //PRECIO PARA MIEMBROS
                WidgetRichText(
                  text: 'Precio para miembros:  ',
                  text2: '\$ ${productData['PRECIO PARA MIEMBROS']}',
                  text3: '',
                  textAlign: TextAlign.start,
                ),
                //ATRIBUTO DE LA PLANTILLA
                WidgetRichText(
                  text: 'Atributo de la plantilla:  ',
                  text2: productData['ATRIBUTO DE LA PLANTILLA'],
                  text3: '',
                  textAlign: TextAlign.start,
                ),
                //LISTA DE PRECIO
                WidgetRichText(
                  text: 'Lista de precio:  ',
                  text2: productData['LISTA DE PRECIO'],
                  text3: '',
                  textAlign: TextAlign.start,
                ),
                //UNIDAD
                WidgetRichText(
                  text: 'Unidad:  ',
                  text2: productData['UNIDAD'],
                  text3: '',
                  textAlign: TextAlign.start,
                ),
                //NIVEL
                WidgetRichText(
                  text: 'Nivel:  ',
                  text2: productData['NIVEL'],
                  text3: '',
                  textAlign: TextAlign.start,
                ),
                //ORIGEN
                WidgetRichText(
                  text: 'Origen:  ',
                  text2: productData['ORIGEN'],
                  text3: '',
                  textAlign: TextAlign.start,
                ),
                //ESPECIFICACIONES
                WidgetRichText(
                  text: 'Especificaciones:  ',
                  text2: productData['ESPECIFICACIONES'],
                  text3: '',
                  textAlign: TextAlign.start,
                ),
                //PROVEEDOR
                WidgetRichText(
                  text: 'Proveedor:  ',
                  text2: productData['userName'],
                  text3: '',
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
