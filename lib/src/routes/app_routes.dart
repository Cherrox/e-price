import 'package:e_price/src/screen.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.login: (_) => const LoginPage(),
  };
}
