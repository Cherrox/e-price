// ignore_for_file: sort_child_properties_last, unnecessary_this

import 'package:e_price/src/screen.dart';
import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: Colors.red,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _PurpleBox(),
          _HeaderIcon(),
          this.child,
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        margin: const EdgeInsets.only(top: 30),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            'assets/icons/logob2.png',
            width: 80,
            height: 150,
          ),
        ),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _purpleBackground(),
      child: Stack(
        children: [
          Positioned(child: _Bubble(), top: 90, left: 30),
          Positioned(child: _Bubble(), top: -40, left: -30),
          Positioned(child: _Bubble(), top: -50, right: -20),
          Positioned(child: _Bubble(), bottom: -50, left: 10),
          Positioned(child: _Bubble(), bottom: 120, right: 20),
        ],
      ),
    );
  }

  BoxDecoration _purpleBackground() => const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.pink,
            AppColors.orange,
            // AppColors.pink,
          ],
          end: Alignment.bottomCenter,
          // begin: Alignment.topCenter,
        ),
      );
}

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromRGBO(255, 255, 255, 0.05)),
    );
  }
}
