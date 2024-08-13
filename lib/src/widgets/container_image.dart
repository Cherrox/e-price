import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_price/src/screen.dart';
import 'package:flutter/material.dart';

class ContainerImage extends StatelessWidget {
  final String imageUSer;
  final double height;
  final double width;
  const ContainerImage({
    super.key,
    required this.imageUSer,
    this.height = 50,
    this.width = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: AppColors.pink,
        border: Border.all(
          width: 2,
          color: AppColors.orangeAccent,
        ),
      ),
      child: CachedNetworkImage(
        imageUrl: imageUSer,
        cacheKey: imageUSer,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image(
            height: height,
            width: width,
            fit: BoxFit.cover,
            image: const AssetImage("assets/gif/circle.gif"),
          ),
        ),
        errorWidget: (context, url, error) => ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image(
            height: height,
            width: width,
            fit: BoxFit.cover,
            image: const AssetImage("assets/images/noimage.png"),
          ),
        ),
      ),
    );
  }
}
