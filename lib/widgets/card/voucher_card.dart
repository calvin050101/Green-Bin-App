import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/voucher_model.dart';
import '../../providers/user_provider.dart';
import '../../services/voucher_service.dart';

class VoucherCard extends ConsumerWidget {
  final Voucher voucher;

  const VoucherCard({super.key, required this.voucher});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(currentUserStreamProvider);

    return userAsyncValue.when(
      data: (user) {
        if (user == null) return const SizedBox.shrink();

        final userId = user.uid;
        final isRedeemed = user.redeemedVouchers?.any(
          (rv) => rv.voucherId == voucher.id,
        );
        if (isRedeemed == null) return const SizedBox.shrink();

        return Card(
          color: Colors.white,
          child: ListTile(
            title: Text(
              voucher.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "OpenSans",
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  voucher.description,
                  style: const TextStyle(fontFamily: "OpenSans", fontSize: 14),
                ),
                Text(
                  "Cost: ${voucher.cost} points",
                  style: const TextStyle(
                    fontFamily: "OpenSans",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                redeemVoucher(context, ref, userId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isRedeemed
                        ? Colors.grey
                        : Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                isRedeemed ? "Redeemed" : "Redeem",
                style: const TextStyle(
                  fontFamily: "OpenSans",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Text('Error: $err'),
    );
  }

  void redeemVoucher(BuildContext context, WidgetRef ref, String userId) async {
    try {
      await ref.read(voucherServiceProvider).redeemVoucher(userId, voucher);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: Text(
            "Redeemed ${voucher.title}!",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } catch (e, st) {
      debugPrint('Redeem failed: $e');
      debugPrintStack(stackTrace: st);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}
