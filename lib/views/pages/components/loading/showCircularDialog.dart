import 'package:flutter/material.dart';

void showCircularDialog(BuildContext context) {
  
   WidgetsBinding.instance.addPostFrameCallback(
    (_) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
      child: CircularProgressIndicator(),
    ),
  );
  }
   );
}