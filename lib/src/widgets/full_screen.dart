import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_price/src/screen.dart';
import 'package:flutter/material.dart';

class FullScreen extends StatelessWidget {
  final String foto;

  const FullScreen(this.foto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      appBar: AppBar(
        backgroundColor: AppColors.darkColor,
        centerTitle: true,
        title: const Text(
          'Imagen Completa',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "PB",
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Hero(
          tag: foto,
          child: CachedNetworkImage(
            imageUrl: foto,
            cacheKey: foto,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            placeholder: (context, url) => ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image.asset(
                "assets/gif/vertical.gif",
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
