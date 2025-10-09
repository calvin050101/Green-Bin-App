import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/helper/list_view_functions.dart';
import '../../providers/voucher_providers.dart';
import '../../widgets/back_button.dart';
import '../../widgets/card/voucher_card.dart';

class VoucherListPage extends ConsumerWidget {
  static String routeName = "/voucher-list";

  const VoucherListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vouchersAsync = ref.watch(availableVouchersProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Vouchers",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 32,
            fontFamily: 'Poppins',
          ),
        ),
        leadingWidth: 70,
        leading: CustBackButton(),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
        child: vouchersAsync.when(
          data:
              (vouchers) => listVerticalItems(
                vouchers,
                (context, voucher) => VoucherCard(voucher: voucher),
                "No vouchers available",
              ),
          loading: () => Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text("Error: $e")),
        ),
      ),
    );
  }
}
