import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:green_bin/models/redeemed_vouchers_model.dart';

class RedeemedVoucherCard extends StatelessWidget {
  final RedeemedVoucher voucher;
  const RedeemedVoucherCard({super.key, required this.voucher});

  @override
  Widget build(BuildContext context) {
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ClipRRect voucherImg() => ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: CachedNetworkImage(
      imageUrl: voucher.imageUrl,
      width: 80,
      height: 80,
      fit: BoxFit.scaleDown,
      errorWidget:
          (context, error, stackTrace) => Container(
        width: 80,
        height: 80,
        color: Colors.grey[300],
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported, size: 30),
      ),
    ),
  );
}
