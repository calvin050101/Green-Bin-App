import 'package:flutter/services.dart' show rootBundle;
import 'package:green_bin/constants/assets.dart';

class Labels {
  static List<String> _labels = [];

  static Future<void> loadLabels() async {
    final raw = await rootBundle.loadString(AppAssets.labels);
    _labels =
        raw
            .split('\n')
            .map((l) => l.trim())
            .where((l) => l.isNotEmpty)
            .toList();
  }

  static String labelAt(int index) => _labels[index];

  static int get length => _labels.length;
}
