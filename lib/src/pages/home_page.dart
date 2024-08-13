import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final dynamic userDatos;
  const HomePage({super.key, this.userDatos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Text(userDatos['username'],
          ), 
        ],),
      ),
    );
  }
}