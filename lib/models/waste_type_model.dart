import 'package:cloud_firestore/cloud_firestore.dart';

class WasteTypeModel {
  final String id;
  final String label;
  final int pointsPerKg;
  final double carbonPerKg;

  WasteTypeModel({
    required this.id,
    required this.label,
    required this.pointsPerKg,
    required this.carbonPerKg,
  });

  factory WasteTypeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WasteTypeModel(
      id: doc.id,
      label: data['label'],
      pointsPerKg: data['pointsPerKg'],
      carbonPerKg: data['carbonPerKg'].toDouble()
    );
  }
}