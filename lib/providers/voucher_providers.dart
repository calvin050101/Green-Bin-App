import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/voucher_service.dart';
import '../models/voucher_model.dart';

/// Stream of all active vouchers
final availableVouchersProvider = StreamProvider<List<Voucher>>((ref) {
  final service = ref.watch(voucherServiceProvider);
  return service.getAvailableVouchers();
});

/// Stream of redeemed vouchers for the current user
final userVouchersProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((ref, userId) {
      final service = ref.watch(voucherServiceProvider);
      return service.getUserVouchers(userId);
    });

/// Redeem voucher action
final redeemVoucherProvider =
    FutureProvider.family<void, (String userId, Voucher voucher)>((
      ref,
      params,
    ) {
      final service = ref.watch(voucherServiceProvider);
      return service.redeemVoucher(params.$1, params.$2);
    });
