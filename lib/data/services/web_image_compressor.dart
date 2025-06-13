import 'dart:typed_data';
import 'package:image/image.dart' as img;

class WebImageCompressor {
  static Future<Uint8List?> compressImageWeb(Uint8List data, {int quality = 50}) async {
    try {
      final image = img.decodeImage(data);
      if (image == null) return null;

      final compressed = img.encodeJpg(image, quality: quality);
      print("image compressed");
      return Uint8List.fromList(compressed);
    } catch (e) {
      print("Error compressing image on web: $e");
      return null;
    }
  }
}