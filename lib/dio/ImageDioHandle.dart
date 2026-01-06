// services/image_dio_handle.dart
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class ImageDioHandle {
  static final ImageDioHandle instance = ImageDioHandle._internal();
  late final Dio dio;

  final String _apiKey = 'cb320ade3104431fb0e92adeae8edc57';

  ImageDioHandle._internal() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  Future<String> uploadToImgBB(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final formData = FormData.fromMap({
      'key': _apiKey,
      'image': base64Image,
    });

    final response = await dio.post(
      'https://api.imgbb.com/1/upload',
      data: formData,
    );

    return response.data['data']['url'];
  }
}
