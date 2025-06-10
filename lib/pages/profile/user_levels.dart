import 'package:flutter/material.dart';

import '../../widgets/back_button.dart';
import '../../widgets/cust_container.dart';

class UserLevelsPage extends StatelessWidget {
  const UserLevelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: CustBackButton(),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'User Levels',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  fontFamily: 'Poppins',
                ),
              ),

              SizedBox(height: 40),

              userLevelContainer("0-99 Points", "Seedling 🌱"),
              userLevelContainer("100-249 Points", "Sprout 🍃"),
              userLevelContainer("250-499 Points", "Leaflet 🍂"),
              userLevelContainer("500-999 Points", "Green Guardian 🌿"),
              userLevelContainer("1000-1999 Points", "Eco Warrior ♻️"),
              userLevelContainer("2000-3999 Points", "Planet Protector 🌍"),
              userLevelContainer("4000+ Points", "Recycling Champion 🏆"),
            ],
          ),
        ),
      ),
    );
  }

  Padding userLevelContainer(String points, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: CustContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              points,
              style: TextStyle(fontSize: 16, fontFamily: 'OpenSans'),
            ),

            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
