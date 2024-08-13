import 'dart:io';
import 'package:e_price/src/screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final dynamic userData;
  const EditProfile({super.key, this.userData});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? imageUrl;
  File? image;

  @override
  void initState() {
    final authProvider = Provider.of<AuthProviderP>(context, listen: false);
    super.initState();
    imageUrl = widget.userData['imageUser'];
    authProvider.usernameController.text = widget.userData['username'];
  }

  Future<void> selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderP>(context);
    final isLoading = authProvider.isLoading;
    return Scaffold(
      backgroundColor: AppColors.blueColors,
      appBar: AppBar(
        backgroundColor: AppColors.blueColors,
        iconTheme: const IconThemeData(color: AppColors.white),
        centerTitle: true,
        title: const Text(
          "Editar Perfil",
          style: TextStyle(
            fontFamily: "MonB",
            color: AppColors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: authProvider.formKeyEdit,
          child: Column(
            children: [
              const SizedBox(height: 20),
              InkWell(
                borderRadius: BorderRadius.circular(100),
                splashColor: AppColors.blueColors,
                onTap: selectImage,
                child: CircleAvatar(
                  backgroundColor: AppColors.blueColors,
                  radius: 80,
                  child: Stack(
                    children: [
                      ClipOval(
                        child: image != null
                            ? Image.file(
                                image!,
                                width: 160,
                                height: 160,
                                fit: BoxFit.cover,
                              )
                            : imageUrl != null
                                ? ContainerImage(
                                    height: 160,
                                    width: 160,
                                    imageUSer: imageUrl!,
                                  )
                                : const Icon(
                                    Icons.camera_alt_rounded,
                                    size: 40,
                                    color: AppColors.white,
                                  ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                            border: Border.all(
                              width: 2,
                              color: AppColors.orangeAccent,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.camera_alt,
                              color: AppColors.blueColors,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InputDecorationWidget(
                color: AppColors.headerColor,
                hintText: "Ingresa tu nuevo nombre de Usuario",
                labelText: "Nombre de usuario",
                keyboardType: TextInputType.emailAddress,
                suffixIcon: const Icon(Icons.person_rounded,
                    color: AppColors.headerColor),
                controller: authProvider.usernameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "El nombre de usuario no puede estar vacio";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              isLoading
                  ? const CircularProgressWidget(
                      text: "Actualizando", color: AppColors.orangeAccent)
                  : MaterialButtomWidget(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      title: "Actualizar perfil",
                      color: AppColors.orangeAccent,
                      onPressed: () {
                        authProvider.editarPerfil(
                          image: image,
                          userData: widget.userData,
                          username: authProvider.usernameController.text,
                          context: context,
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
