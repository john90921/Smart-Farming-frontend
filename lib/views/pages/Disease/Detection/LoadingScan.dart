import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class Loadingscan extends StatefulWidget {
  const Loadingscan({super.key, required this.image});
  final File image;

  @override
  State<Loadingscan> createState() => _LoadingscanState();
}

class _LoadingscanState extends State<Loadingscan> {
  late Interpreter interpreter;

  Future<void> loadModel() async {
  interpreter = await Interpreter.fromAsset('mobilenet_v3.tflite');
}
  @override
  void initState() {
    loadModel();
    // TODO: implement initState
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Scanning Photo... Please wait'),
          ],
        ),
      ),
    );
  }
}