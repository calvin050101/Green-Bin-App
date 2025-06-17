import 'package:flutter/material.dart';
import 'package:green_bin/pages/auth/update_username.dart';

import '../../widgets/back_button.dart';
import '../auth/change_password.dart';

class SettingsPage extends StatelessWidget {
  static String routeName = "/settings";
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: CustBackButton(),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),

            Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 32,
                fontFamily: 'Poppins',
              ),
            ),

            SizedBox(height: 20.0),

            Text(
              'Profile',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                fontFamily: 'OpenSans',
              ),
            ),

            SizedBox(height: 15),

            profileUpdateLink(
              route: UpdateUsernamePage.routeName,
              name: "Update Username",
              context: context,
            ),

            Divider(color: Color(0xFFD6D6D6), thickness: 1),

            profileUpdateLink(
              route: ChangePasswordPage.routeName,
              name: "Change Password",
              context: context,
            ),

            const SizedBox(height: 40),

            Text(
              'Device',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                fontFamily: 'OpenSans',
              ),
            ),

            SizedBox(height: 20.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.location_pin),
                SizedBox(width: 10),
                Text(
                  "Manage Location Services",
                  style: TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
                ),
              ],
            ),

            Divider(color: Color(0xFFD6D6D6), thickness: 1),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.camera_alt_outlined),
                SizedBox(width: 10),
                Text(
                  "Manage Camera Access",
                  style: TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
                ),
              ],
            ),

            const SizedBox(height: 40),

            deleteAccountButton(),
          ],
        ),
      ),
    );
  }

  GestureDetector profileUpdateLink({
    required String route,
    required String name,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontSize: 20, fontFamily: 'OpenSans')),

          Icon(Icons.arrow_forward_ios_rounded),
        ],
      ),
    );
  }

  SizedBox deleteAccountButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: const Text(
          'Delete Account',
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
}
