import 'package:green_bin/models/record_model.dart';
import 'package:green_bin/models/waste_type_model.dart';

import '../helper/helper_functions.dart';

class RecyclingSummary {
  final int totalPoints;
  final double totalCarbonFootprintSaved;

  RecyclingSummary({
    required this.totalPoints,
    required this.totalCarbonFootprintSaved,
  });
}

RecyclingSummary calculateRecyclingSummary(List<RecordModel>? records) {
  int totalPoints = 0;
  double totalCarbonFootprintSaved = 0.0;

  if (records == null || records.isEmpty) {
    return RecyclingSummary(totalPoints: 0, totalCarbonFootprintSaved: 0.0);
  }

  for (var record in records) {
    final WasteTypeModel wasteInfo = getWasteType(record.wasteType);
    totalPoints += wasteInfo.points;
    totalCarbonFootprintSaved += wasteInfo.carbonFootprint;
  }

  totalCarbonFootprintSaved = double.parse(
    totalCarbonFootprintSaved.toStringAsFixed(2),
  );

  return RecyclingSummary(
    totalPoints: totalPoints,
    totalCarbonFootprintSaved: totalCarbonFootprintSaved,
  );
}
