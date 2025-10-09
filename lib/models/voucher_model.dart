import 'package:cloud_firestore/cloud_firestore.dart';

class Voucher {
  final String id;
  final String title;
  final String description;
  final int cost;
  final String imageUrl;
  final bool active;

  Voucher({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
    required this.imageUrl,
    required this.active,
  });

  factory Voucher.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Voucher(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      cost: data['cost'] ?? 0,
      imageUrl: data['imageUrl'] ?? '',
      active: data['active'] ?? true,
    );
  }
}