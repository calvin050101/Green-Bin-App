class RecordModel {
  final String id;
  final String wasteType;
  final DateTime timestamp;
  final double weight;

  RecordModel({
    required this.id,
    required this.timestamp,
    required this.wasteType,
    required this.weight,
  });

  factory RecordModel.fromFirestore(Map<String, dynamic> data, String id) {
    return RecordModel(
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
