import 'package:fv2/dio/ImageDioHandle.dart';

class ImageService {
  Future<String?> uploadImage(File file) async {
  try {
    final url = await ImageDioHandle.instance.uploadToImgBB(file);
    return url;
  } catch (e) {
    throw Exception('Image upload failed: $e');
  }
}
}