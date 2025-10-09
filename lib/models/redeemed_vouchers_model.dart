import 'package:cloud_firestore/cloud_firestore.dart';

class RedeemedVoucher {
  final String voucherId;
  final String title;
  final String description;
  final int cost;
  final DateTime? redeemedAt;

  RedeemedVoucher({
    required this.voucherId,
    required this.title,
    required this.description,
    required this.cost,
    this.redeemedAt,
  });

  factory RedeemedVoucher.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final ts = data['redeemedAt'];

    return RedeemedVoucher(
      voucherId: data['voucherId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      cost: data['cost'] ?? 0,
      redeemedAt: ts is Timestamp ? ts.toDate() : null,
    );
  }
}
