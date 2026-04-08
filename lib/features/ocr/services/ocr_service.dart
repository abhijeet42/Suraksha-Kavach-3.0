import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OcrService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImageFromGallery() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  Future<XFile?> captureImageWithCamera() async {
    return await _picker.pickImage(source: ImageSource.camera);
  }

  Future<String?> extractTextFromImage(XFile image, {bool useDevanagari = false}) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(
      script: useDevanagari ? TextRecognitionScript.devanagiri : TextRecognitionScript.latin,
    );

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } catch (e) {
      print('Error during OCR: $e');
      return null;
    } finally {
      await textRecognizer.close();
    }
  }
}
