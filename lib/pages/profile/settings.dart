import 'package:flutter/material.dart';
import 'package:green_bin/pages/auth/update_username.dart';
import 'package:green_bin/services/auth_service.dart';

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

            deleteAccountButton(context),
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

  SizedBox deleteAccountButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            () => _confirmDeleteAccount(
              context,
              authService.value.currentUser!.email!,
            ),
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

  Future<void> _confirmDeleteAccount(BuildContext context, String email) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Delete Account"),
            content: const Text(
              "Are you sure you want to permanently delete your account? "
              "This action cannot be undone.",
            ),
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text("Cancel", style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text("Delete", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );

    if (!context.mounted) return;

    if (shouldDelete == true) {
      final password = await _showPasswordDialog(context);
      if (password == null || password.isEmpty) return;

      try {
        await authService.value.deleteAccount(
            email: authService.value.currentUser!.email!,
            password: password
        );

        if (!context.mounted) return;
        Navigator.of(context).pushReplacementNamed('/');
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error deleting account: $e")));
      }
    }
  }

  Future<String?> _showPasswordDialog(BuildContext context) async {
    final TextEditingController passwordController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Re-enter Password"),
            backgroundColor: Colors.white,
            content: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(null),
                child: const Text("Cancel", style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop(passwordController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text("Confirm", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }
}
