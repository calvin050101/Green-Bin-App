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
          elevation: 3,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🖼️ Image section
                voucherImg(),
                const SizedBox(width: 12),

                // 📄 Info + Button section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        voucher.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "OpenSans",
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        voucher.description,
                        style: const TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Cost: ${voucher.cost} points",
                        style: const TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Align(
                        alignment: Alignment.centerRight,
                        child: redeemButton(context, ref, userId, isRedeemed),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Text('Error: $err'),
    );
  }

  ElevatedButton redeemButton(
    BuildContext context,
    WidgetRef ref,
    String userId,
    bool isRedeemed,
  ) => ElevatedButton(
    onPressed: () async {
      redeemVoucher(context, ref, userId);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor:
          isRedeemed ? Colors.grey : Theme.of(context).colorScheme.primary,
      minimumSize: const Size(100, 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Text(
      isRedeemed ? "Redeemed" : "Redeem",
      style: const TextStyle(
        fontFamily: "OpenSans",
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  ClipRRect voucherImg() => ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Image.network(
      voucher.imageUrl,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder:
          (context, error, stackTrace) => Container(
            width: 80,
            height: 80,
            color: Colors.grey[300],
            alignment: Alignment.center,
            child: const Icon(Icons.image_not_supported, size: 30),
          ),
    ),
  );

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
