import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget showPage(user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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

          userStatsContainer(context),

          const SizedBox(height: 30),

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

          logOutButton(),

          const SizedBox(height: 10),

          Center(
            child: Text(
              "App version: v1.0.0",
              style: TextStyle(fontSize: 14, fontFamily: "OpenSans"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),

      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: DatabaseService().getUserData(),
        builder: (context, snapshot) {
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (!snapshot.hasData) {
            return Text("No data");
          } else {
            Map<String, dynamic>? user = snapshot.data!.data();
            return showPage(user);
          }
        },
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

  SizedBox logOutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          await authService.value.signOut();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00B0FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: const Text(
          'Log Out',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
    );
  }

  Container userStatsContainer(BuildContext context) {
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
              rowValue: "15",
              context: context,
            ),

            SizedBox(height: 15),

            userStatsRow(
              rowIcon: Icon(Icons.cloud, size: 40, color: Colors.grey),
              rowTitle: "CO₂ Saved",
              rowValue: "8.5 kg",
              context: context,
            ),

            SizedBox(height: 15),

            userStatsRow(
              rowIcon: Icon(Icons.line_axis, size: 40, color: Colors.amber),
              rowTitle: "Streak",
              rowValue: "12 days",
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

  Row profileInfo(user) {
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
              user!["username"],
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
                fontFamily: 'OpenSans',
              ),
            ),

            SizedBox(height: 6),

            Text(
              "${user!["points"]} Points",
              style: TextStyle(fontSize: 18, fontFamily: 'OpenSans'),
            ),

            SizedBox(height: 6),

            Text(
              "Recycler Level 3",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                fontFamily: 'OpenSans',
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
