import 'package:cloud_firestore/cloud_firestore.dart';

class WasteRecord {
  final String id;
  final String wasteType;
  final DateTime timestamp;
  final double weight;

  WasteRecord({
    required this.id,
    required this.timestamp,
    required this.wasteType,
    required this.weight,
  });

  factory WasteRecord.fromFirestore(DocumentSnapshot doc, String id) {
    final data = doc.data() as Map<String, dynamic>;
    return WasteRecord(
      id: id,
      timestamp: data['timestamp'].toDate(),
      wasteType: data['wasteType'],
      weight: data['weight'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'timestamp': timestamp,
      'wasteType': wasteType,
      'weight': weight,
    };
  }
}
