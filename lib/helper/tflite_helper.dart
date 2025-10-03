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
    if (_isInitialized) return;

    try {
      _interpreter = await Interpreter.fromAsset(
        AppAssets.wasteClassificationModel,
      );

      _isInitialized = true;
    } catch (e) {
      rethrow;
    }
  }

  /// Accessor for interpreter
  static Interpreter get interpreter {
    if (!_isInitialized) throw Exception("Model not initialized");
    return _interpreter;
  }

  /// Preprocess and flatten to Float32List in NHWC order
  static Float32List preprocessImageFromPath(String imagePath) {
    final imageFile = File(imagePath);
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

  /// Runs inference given preprocessed input
  static Future<Map<String, dynamic>> runInferenceFromInput(
    Float32List input,
  ) async {
    var outputShape = interpreter.getOutputTensor(0).shape;
    var outputBuffer = Float32List(outputShape.reduce((a, b) => a * b));

    interpreter.run(input.buffer, outputBuffer.buffer);

    // Top prediction
    final outputs = outputBuffer.toList();
    int maxIndex = 0;
    double maxValue = outputs[0];
    for (int i = 1; i < outputs.length; i++) {
      if (outputs[i] > maxValue) {
        maxIndex = i;
        maxValue = outputs[i];
      }
    }
    return {"label": Labels.labelAt(maxIndex), "confidence": maxValue};
  }
}
