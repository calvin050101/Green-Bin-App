import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/constants/assets.dart';
import 'package:green_bin/helper/list_view_functions.dart';
import 'package:green_bin/pages/vouchers/voucher_list_page.dart';
import '../models/user_level_model.dart';
import '../widgets/card/redeemed_voucher_card.dart';
import '../widgets/cust_container.dart';
import '../widgets/card/waste_type_summary_card.dart';
import '../widgets/card/fun_fact_card.dart';

import '../helper/waste_type_functions.dart';
import '../models/user_model.dart';
import '../models/waste_type_summary.dart';

class HomePage extends ConsumerWidget {
  final AsyncValue<UserModel?> userAsyncValue;

  const HomePage({super.key, required this.userAsyncValue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return userAsyncValue.when(
      data: (user) {
        if (user == null) {
          return const Center(child: Text('User not logged in.'));
        }

        return Scaffold(
          appBar: buildAppBar(context),
          body: SingleChildScrollView(child: showHome(user, context, ref)),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          "GreenBin",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 32,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget showHome(UserModel user, BuildContext context, WidgetRef ref) {
    final List<WasteTypeSummary> wasteTypeCounts = getWasteTypeCounts(
      user.records,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        topBanner(context),
        const SizedBox(height: 40),

        // Welcome Text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Welcome, ${user.username}",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Points Progress Container
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: pointsProgressContainer(user, context),
        ),
        const SizedBox(height: 20),

        // Carbon Footprint Saved Facts
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            user.totalCarbonSaved == 0
                ? "Start recycling to get stats"
                : "That is like...",
            style: TextStyle(
              fontFamily: user.totalCarbonSaved == 0 ? 'OpenSans' : 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 20),

        if (user.totalCarbonSaved! > 0) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: funFactContainer(user, context),
          ),
          const SizedBox(height: 20),
        ],

        // Recycling Waste Counts
        if (user.records!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              "Recycling Stats",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 140,
                  child: listHorizontalItems(
                    items: wasteTypeCounts,
                    itemBuilder:
                        (context, wasteTypeCount) =>
                            WasteTypeSummaryCard(summary: wasteTypeCount),
                    emptyText: "No waste records found.",
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // List of vouchers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "My Vouchers",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, VoucherListPage.routeName);
                  },
                  icon: const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Colors.blueAccent,
                  ),
                  label: const Text(
                    "See all vouchers",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.blueAccent,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(60, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: listVerticalItems(
              items: user.redeemedVouchers!,
              itemBuilder:
                  (context, voucher) => RedeemedVoucherCard(voucher: voucher),
              emptyText: "No vouchers found.",
            ),
          ),

          const SizedBox(height: 40),
        ],
      ],
    );
  }

  SizedBox topBanner(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          // Background Image with Opacity
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,
              child: Image.asset(AppAssets.greenBinBanner, fit: BoxFit.cover),
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Sort Smarter. Recycle Better.",
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    "Let GreenBin guide you to a cleaner tomorrow.",
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  CustContainer pointsProgressContainer(UserModel user, BuildContext context) {
    final userPoints = user.totalPoints! | 0;
    final totalCarbonSaved = user.totalCarbonSaved!;
    final UserLevel userLevel = getUserLevel(userPoints);
    final double progress = min(
      (userPoints - userLevel.minPoints) / userLevel.maxPoints,
      1,
    );

    return CustContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "You have saved ${totalCarbonSaved.toStringAsFixed(2)} kg CO₂ by recycling.",
            style: TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.w600,
              fontSize: 16,
              fontFamily: 'OpenSans',
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
              backgroundColor: Color(0xFF333333),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userPoints >= 4000
                    ? "4000+ points"
                    : "$userPoints/${userLevel.maxPoints} points",
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: 'OpenSans',
                ),
              ),

              Text(
                userLevel.levelName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  fontFamily: 'OpenSans',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column funFactContainer(UserModel user, BuildContext context) {
    final carbonFootprint = user.totalCarbonSaved!;

    // List of fun facts with an icon
    final funFacts = [
      {
        'icon': Icons.local_drink,
        'text': 'Avoiding ${(carbonFootprint * 80).toInt()} plastic bottles.',
      },
      {
        'icon': Icons.directions_car,
        'text': '${(carbonFootprint * 4).toInt()} km of driving.',
      },
      {
        'icon': Icons.forest,
        'text':
            'Saving ${(carbonFootprint / 20).toStringAsFixed(2)} trees per year.',
      },
      {
        'icon': Icons.lightbulb,
        'text':
            'Powering a lightbulb for ${(carbonFootprint * 10).toInt()} hours.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
          child: listHorizontalItems(
            items: funFacts,
            itemBuilder:
                (context, fact) => FunFactCard(
                  icon: fact['icon'] as IconData,
                  text: fact['text'] as String,
                ),
            emptyText: "No fun facts found.",
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
