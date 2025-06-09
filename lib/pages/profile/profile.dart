import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/widgets/custom_button.dart';
import '../../helper/helper_functions.dart';
import '../../models/recycling_summary.dart';
import '../../models/user_level_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  final AsyncValue<UserModel?> userAsyncValue;

  const ProfilePage({super.key, required this.userAsyncValue});

  @override
  Widget build(BuildContext context) {
    return userAsyncValue.when(
      data: (user) {
        if (user == null) {
          return const Center(child: Text('User not logged in.'));
        }

        return Scaffold(
          appBar: AppBar(backgroundColor: Colors.transparent),
          body: showPage(user, context),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget showPage(UserModel user, BuildContext context) {
    final RecyclingSummary summary =
        user.records != null
            ? calculateRecyclingSummary(user.records)
            : RecyclingSummary(totalPoints: 0, totalCarbonFootprintSaved: 0);

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'Profile',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 32,
                fontFamily: 'Poppins',
              ),
            ),

            const SizedBox(height: 40),

            profileInfo(user, summary),

            const SizedBox(height: 30),

            userStatsContainer(user, summary, context),

            const SizedBox(height: 30),

            pageDirectButton(
              route: '/user-levels',
              buttonText: "User Levels",
              context: context,
            ),

            const SizedBox(height: 10),

            pageDirectButton(
              route: '/recycling-history',
              buttonText: "Recycling History",
              context: context,
            ),

            const SizedBox(height: 10),

            pageDirectButton(
              route: '/settings',
              buttonText: "Settings",
              context: context,
            ),

            const SizedBox(height: 20),

            CustomButton(
              buttonText: "Log Out",
              onPressed: () async {
                await authService.value.signOut();
              },
            ),

            const SizedBox(height: 10),

            Center(
              child: Text(
                "App version: v1.0.0",
                style: TextStyle(fontSize: 14, fontFamily: "OpenSans"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell pageDirectButton({
    required String route,
    required String buttonText,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },

      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFD6D6D6), width: 2),
        ),

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                buttonText,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  fontFamily: 'OpenSans',
                ),
              ),

              Icon(Icons.arrow_forward_ios_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Container userStatsContainer(UserModel user, RecyclingSummary summary, BuildContext context) {
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
          children: [
            userStatsRow(
              rowIcon: Icon(
                Icons.recycling,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              rowTitle: "Items Sorted",
              rowValue: '${user.records?.length}',
              context: context,
            ),

            SizedBox(height: 15),

            userStatsRow(
              rowIcon: Icon(Icons.cloud, size: 40, color: Colors.grey),
              rowTitle: "CO₂ Saved",
              rowValue: "${summary.totalCarbonFootprintSaved} kg",
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Row userStatsRow({
    required Icon rowIcon,
    required String rowTitle,
    required String rowValue,
    required BuildContext context,
  }) {
    return Row(
      children: [
        rowIcon,
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rowTitle,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: 'OpenSans',
              ),
            ),
            SizedBox(height: 4),
            Text(
              rowValue,
              style: TextStyle(fontSize: 16, fontFamily: 'OpenSans'),
            ),
          ],
        ),
      ],
    );
  }

  Row profileInfo(UserModel user, RecyclingSummary summary) {
    final UserLevel userLevel = getUserLevel(summary.totalPoints);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Color(0xFFD9DCE1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.person, size: 90, color: Color(0xFF70777F)),
        ),

        SizedBox(width: 25),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.username ?? '',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
                fontFamily: 'OpenSans',
              ),
            ),

            SizedBox(height: 6),

            Text(
              "${summary.totalPoints} Points",
              style: TextStyle(fontSize: 18, fontFamily: 'OpenSans'),
            ),

            SizedBox(height: 6),

            Text(
              userLevel.levelName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                fontFamily: 'OpenSans',
                color: Color(0xFF4CAF50),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
