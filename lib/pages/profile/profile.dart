import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/pages/profile/recycling_history.dart';
import 'package:green_bin/pages/profile/settings.dart';
import 'package:green_bin/pages/profile/user_levels.dart';
import 'package:green_bin/widgets/cust_container.dart';
import 'package:green_bin/widgets/custom_button.dart';
import 'package:green_bin/widgets/page_direct_container.dart';
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

            profileInfo(user),
            const SizedBox(height: 30),

            userStatsContainer(user, context),
            const SizedBox(height: 30),

            PageDirectContainer(
              text: "User Levels",
              onTap: () {
                Navigator.pushNamed(context, UserLevelsPage.routeName);
              },
            ),
            const SizedBox(height: 10),

            PageDirectContainer(
              text: "Recycling History",
              onTap: () {
                Navigator.pushNamed(context, RecyclingHistoryPage.routeName);
              },
            ),
            const SizedBox(height: 10),

            PageDirectContainer(
              text: "Settings",
              onTap: () {
                Navigator.pushNamed(context, SettingsPage.routeName);
              },
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

  Row profileInfo(UserModel user) {
    final UserLevel userLevel = getUserLevel(user.totalPoints!);

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
              "${user.totalPoints!} Points",
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

  CustContainer userStatsContainer(
    UserModel user,
    BuildContext context,
  ) {
    return CustContainer(
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
            rowValue: "${user.totalCarbonSaved} kg",
            context: context,
          ),
        ],
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
}
