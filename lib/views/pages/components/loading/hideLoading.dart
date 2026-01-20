import 'package:flutter/material.dart';

void hideLoading(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}