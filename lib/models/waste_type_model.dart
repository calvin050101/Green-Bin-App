import 'package:cloud_firestore/cloud_firestore.dart';

class WasteTypeModel {
  final String id;
  final String label;
  final int points;
  final double carbonFootprint;

  WasteTypeModel({
    required this.id,
    required this.label,
    required this.points,
    required this.carbonFootprint,
  });

  factory WasteTypeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WasteTypeModel(
      id: doc.id,
      label: data['label'],
      points: data['points'],
      carbonFootprint: data['carbonFootprint'].toDouble()
    );
  }
}