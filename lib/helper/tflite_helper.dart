import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import '../constants/assets.dart';
import 'labels.dart';

class TFLiteHelper {
  static late Interpreter _interpreter;
  static bool _isInitialized = false;

  /// Initialize TFLite model and labels
  static Future<void> init() async {
    try {
      // Load model
      _interpreter = await Interpreter.fromAsset(
        AppAssets.wasteClassificationModel,
      );

      _isInitialized = true;
      print("✅ TFLite model and labels loaded successfully");
    } catch (e) {
      print("❌ Failed to load model or labels: $e");
    }
  }

  /// Accessor for interpreter
  static Interpreter get interpreter {
    if (!_isInitialized) throw Exception("Model not initialized");
    return _interpreter;
  }

  /// Preprocess and flatten to Float32List in NHWC order
  static Float32List preprocessImage(File imageFile) {
    final image = img.decodeImage(imageFile.readAsBytesSync())!;
    final resizedImage = img.copyResize(image, width: 224, height: 224);

    final floats = Float32List(1 * 224 * 224 * 3); // NHWC
    int index = 0;

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resizedImage.getPixel(x, y);

        floats[index++] = pixel.r.toDouble(); // R
        floats[index++] = pixel.g.toDouble(); // G
        floats[index++] = pixel.b.toDouble(); // B
      }
    }

    return floats;
  }

  /// Run inference on a given image file
  static Future<Map<String, dynamic>> runInference(File image) async {
    // Preprocess → Float32List in NHWC order
    final input = preprocessImage(image);

    // Prepare output buffer
    var outputShape = interpreter.getOutputTensor(0).shape; // e.g. [1, 10]
    var outputBuffer = Float32List(outputShape.reduce((a, b) => a * b));

    // Run inference
    interpreter.run(input.buffer, outputBuffer.buffer);

    // Convert to list
    final outputs = outputBuffer.toList();

    // 🔹 Find Top-3 predictions
    final indexed = List.generate(outputs.length, (i) => MapEntry(i, outputs[i]));
    indexed.sort((a, b) => b.value.compareTo(a.value));

    final top3 = indexed.take(3).map((e) {
      return {
        "label": Labels.labelAt(e.key),
        "confidence": e.value, // %
      };
    }).toList();

    // Return Top-1 separately for convenience
    return {
      "label": Labels.labelAt(indexed.first.key),
      "confidence": indexed.first.value,
      "top3": top3,
    };
  }
}
