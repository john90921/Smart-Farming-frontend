import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class TfliteService {
  // Example method to demonstrate functionality
Float32List preprocessImage(File imageFile) {
  final bytes = imageFile.readAsBytesSync();
  final image = img.decodeImage(bytes)!;

  // Resize image
  final resized = img.copyResize(image, width: 224, height: 224);

  // Create input buffer
  final input = Float32List(1 * 224 * 224 * 3);
  int index = 0;

  for (int y = 0; y < 224; y++) {
    for (int x = 0; x < 224; x++) {
      final pixel = resized.getPixel(x, y);

      input[index++] = (pixel.r - 127.5) / 127.5;
      input[index++] = (pixel.g - 127.5) / 127.5;
      input[index++] = (pixel.b - 127.5) / 127.5;
    }
  }

  return input;
}
}