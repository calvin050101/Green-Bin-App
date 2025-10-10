import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/models/redeemed_vouchers_model.dart';
import '../models/voucher_model.dart';

final voucherServiceProvider = Provider<VoucherService>((ref) {
  return VoucherService();
});

class VoucherService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Stream all active vouchers
  Stream<List<Voucher>> getAvailableVouchers() {
    return _db
        .collection('vouchers')
        .where('active', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Voucher.fromFirestore(doc)).toList(),
        );
  }

  /// Redeem a voucher if user has enough points
  Future<void> redeemVoucher(String userId, Voucher voucher) async {
    final userDoc = _db.collection('users').doc(userId);
    final redeemedVouchersRef = userDoc
        .collection('redeemedVouchers')
        .doc(voucher.id);

    try {
      await _db.runTransaction((transaction) async {
        final snapshot = await transaction.get(userDoc);

        if (!snapshot.exists) {
          throw Exception('User document does not exist');
        }

        final data = snapshot.data() as Map<String, dynamic>;
        final currentPoints = (data['totalPoints'] ?? 0) as int;

        if (currentPoints < voucher.cost) {
          throw Exception('Not enough points');
        }

        // Deduct points
        transaction.update(userDoc, {
          'totalPoints': currentPoints - voucher.cost,
        });

        // Add redeemed voucher as subdocument
        transaction.set(redeemedVouchersRef, {
          'voucherId': voucher.id,
          'title': voucher.title,
          'description': voucher.description,
          'cost': voucher.cost,
          'redeemedAt': FieldValue.serverTimestamp(),
        });
      });
    } catch (e, st) {
      debugPrint('🔥 Firestore transaction failed: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  /// Stream user's redeemed vouchers
  Stream<List<Map<String, dynamic>>> getUserVouchers(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((doc) {
      final data = doc.data() ?? {};
      final vouchers = (data['redeemedVouchers'] as List?) ?? [];
      return vouchers.map((v) => Map<String, dynamic>.from(v)).toList();
    });
  }

  Future<List<RedeemedVoucher>> getRedeemedVouchers(String userId) async {
    final snapshot =
        await _db
            .collection('users')
            .doc(userId)
            .collection('redeemedVouchers')
            .get();

    return snapshot.docs.map((doc) => RedeemedVoucher.fromFirestore(doc)).toList();
  }
}
