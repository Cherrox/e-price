import 'dart:io';

import 'package:e_price/src/screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//elemento para agregar una imagen desde la galería
Future<void> addImage(BuildContext context, Function(File) onImageSelected) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    onImageSelected(File(pickedFile.path));
  }
}

//elemento para agregar una imagen desde la cámara
Future<void> addImageFromCamera(BuildContext context, Function(File) onImageSelected) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);

  if (pickedFile != null) {
    onImageSelected(File(pickedFile.path));
  }
}

//showdialog para seleccionar la fuente de la imagen
Future<void> showImageSourceDialog(BuildContext context, Function(File) onImageSelected) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Seleccionar fuente de imagen', style: TextStyle(fontFamily: "PB",color: AppColors.orange)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: const Text('Galería', style: TextStyle(fontFamily: "PB",color: AppColors.pink)),
              onTap: () {
                Navigator.pop(context);
                addImage(context, onImageSelected);
              },
              trailing:  const Icon(Icons.image, color: AppColors.pink),
            ),
            ListTile(
              title: const Text('Cámara', style: TextStyle(fontFamily: "PB",color: AppColors.pink)),
              onTap: () {
                Navigator.pop(context);
                addImageFromCamera(context, onImageSelected);
              },
              trailing:  const Icon(Icons.camera_alt_rounded, color: AppColors.pink),
            ),
          ],
        ),
      );
    },
  );
}