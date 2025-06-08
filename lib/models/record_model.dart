class RecordModel {
  final String id;
  final String wasteType;
  final DateTime timestamp;

  RecordModel({required this.id, required this.timestamp, required this.wasteType});

  factory RecordModel.fromFirestore(Map<String, dynamic> data, String id) {
    return RecordModel(
      id: id,
      timestamp: data['timestamp'].toDate(),
      wasteType: data['wasteType'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'id': id, 'timestamp': timestamp, 'wasteType': wasteType};
  }
}
