import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/helper/helper_functions.dart';
import 'package:green_bin/models/user_level_model.dart';

import '../models/user_model.dart';

class HomePage extends StatelessWidget {
  final AsyncValue<UserModel?> userAsyncValue;

  const HomePage({super.key, required this.userAsyncValue});

  @override
  Widget build(BuildContext context) {
    return userAsyncValue.when(
      data: (user) {
        if (user == null) {
          return const Center(child: Text('User not logged in.'));
        }

        return Scaffold(
          appBar: AppBar(
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
          ),
          body: SingleChildScrollView(child: showHome(user, context)),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget showHome(UserModel user, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        topContainer(context),

        const SizedBox(height: 40),

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

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: pointsProgressContainer(user, context),
        ),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: funFactContainer(context),
        ),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: funFactContainer(context),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  Container funFactContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFD6D6D6), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Did you know?",
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: 'OpenSans',
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 50,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Recycling 1 ton of paper is equivalent to saving 17 trees, '
                    'and saves up to 3 cubic yards.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container pointsProgressContainer(UserModel user, BuildContext context) {
    final UserLevel userLevel = getUserLevel(user.points);
    final double progress = min(
      (user.points - userLevel.minPoints) / userLevel.maxPoints,
      1,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFD6D6D6), width: 2),
      ),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "You have saved 8.5 kg CO₂ by recycling.",
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
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
                backgroundColor: Theme.of(context).colorScheme.surface,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user.points >= 4000
                      ? "4000+ points"
                      : "${user.points}/${userLevel.maxPoints} points",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
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
      ),
    );
  }

  SizedBox topContainer(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          // Background Image with Opacity
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,
              child: Image.asset(
                'lib/assets/images/green-bin-banner.png',
                fit: BoxFit.cover,
              ),
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
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    "Let GreenBin guide you to a cleaner tomorrow.",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
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
}
