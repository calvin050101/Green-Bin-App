import 'package:flutter/material.dart';

import '../models/record_model.dart';
import '../models/waste_type_summary.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

IconData getWasteTypeIcon(String wasteType) {
  switch (wasteType) {
    case "Plastic":
      return Icons.liquor;
    case "Paper":
      return Icons.description;
    case "Glass":
      return Symbols.glass_cup;
    case "Metal":
      return Icons.kitchen;
    case "Organic":
      return Icons.eco;
    case "Textiles":
      return Symbols.apparel;
    case "Shoes":
      return Symbols.steps;
    case "E-Waste":
      return Icons.computer;
    case "Non-recyclables":
      return Icons.delete_forever;
    default:
      return Icons.recycling;
  }
}

List<WasteTypeSummary> getWasteTypeCounts(List<WasteRecord>? records) {
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
      icon: getWasteTypeIcon(entry.key),
    );
  }).toList();
}
