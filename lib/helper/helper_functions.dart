import 'package:green_bin/models/user_level_model.dart';
import 'package:green_bin/models/waste_type_model.dart';

UserLevel getUserLevel(int points) {
  if (points < 0) {
    return UserLevel(levelName: "Invalid points", minPoints: 0, maxPoints: 0);
  }

  if (points < 100) {
    return UserLevel(levelName: "Seedling 🌱", minPoints: 0, maxPoints: 100);
  } else if (points < 250) {
    return UserLevel(levelName: "Sprout 🍃", minPoints: 100, maxPoints: 250);
  } else if (points < 500) {
    return UserLevel(levelName: "Leaflet 🍂", minPoints: 250, maxPoints: 500);
  } else if (points < 1000) {
    return UserLevel(
      levelName: "Green Guardian 🌿",
      minPoints: 500,
      maxPoints: 1000,
    );
  } else if (points < 2000) {
    return UserLevel(
      levelName: "Eco Warrior ♻️",
      minPoints: 1000,
      maxPoints: 2000,
    );
  } else if (points < 4000) {
    return UserLevel(
      levelName: "Planet Protector 🌍",
      minPoints: 2000,
      maxPoints: 4000,
    );
  } else {
    return UserLevel(
      levelName: "Recycling Champion 🏆",
      minPoints: 4000,
      maxPoints: 4000,
    );
  }
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
