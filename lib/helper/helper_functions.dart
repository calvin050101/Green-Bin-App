import 'package:flutter/material.dart';

import '../models/record_model.dart';
import '../models/waste_type_summary.dart';

IconData getWasteTypeIcon(String wasteType) {
  switch (wasteType) {
    case "Plastic":
      return Icons.liquor;
    case "Paper":
      return Icons.description;
    case "Glass":
      return Icons.wine_bar;
    case "Metal":
      return Icons.kitchen;
    case "Organic":
      return Icons.eco;
    case "Textiles":
      return Icons.checkroom;
    case "E-Waste":
      return Icons.computer;
    case "Non-recyclables":
      return Icons.delete_forever;
    default:
      return Icons.recycling;
  }
}

List<WasteTypeSummary> getWasteTypeCounts(List<RecordModel>? records) {
  if (records == null || records.isEmpty) {
    return [];
  }

  final Map<String, int> counts = {};
  for (var record in records) {
    counts.update(record.wasteType, (value) => value + 1, ifAbsent: () => 1);
  }

  return counts.entries.map((entry) {
    return WasteTypeSummary(
      wasteType: entry.key,
      count: entry.value,
      icon: getWasteTypeIcon(entry.key), // Get image path
    );
  }).toList();
}
