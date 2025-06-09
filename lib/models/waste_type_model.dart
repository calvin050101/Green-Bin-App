class WasteTypeModel {
  final String wasteType;
  final int points;
  final double carbonFootprint;

  WasteTypeModel({
    required this.wasteType,
    required this.points,
    required this.carbonFootprint,
  });
}

WasteTypeModel getWasteType(String wasteType) {
  switch (wasteType) {
    case "Plastic":
      return WasteTypeModel(
        wasteType: "Plastic",
        points: 5,
        carbonFootprint: 0.03,
      );
    case "Paper":
      return WasteTypeModel(
        wasteType: "Paper",
        points: 4,
        carbonFootprint: 0.06,
      );
    case "Glass":
      return WasteTypeModel(
        wasteType: "Glass",
        points: 6,
        carbonFootprint: 0.15,
      );
    case "Metal":
      return WasteTypeModel(
        wasteType: "Metal",
        points: 6,
        carbonFootprint: 1.35,
      );
    case "Organic":
      return WasteTypeModel(
        wasteType: "Organic",
        points: 7,
        carbonFootprint: 0.07,
      );
    case "Textiles":
      return WasteTypeModel(
        wasteType: "Textiles",
        points: 8,
        carbonFootprint: 0.75,
      );
    case "Non-recyclables":
      return WasteTypeModel(
        wasteType: "Non-recyclables",
        points: 2,
        carbonFootprint: 0.0,
      );
    default:
      return WasteTypeModel(
        wasteType: "Unknown",
        points: 0,
        carbonFootprint: 0.0,
      );
  }
}