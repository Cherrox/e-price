import 'package:e_price/src/screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressWidget(
        color: AppColors.orange,
        text: "Cargando...",
      ),
    );
  }
}
