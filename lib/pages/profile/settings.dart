import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/pages/auth/update_username.dart';

import '../../services/auth_service.dart';
import '../../widgets/back_button.dart';
import '../auth/change_password.dart';

class SettingsPage extends ConsumerWidget {
  static String routeName = "/settings";

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = FirebaseAuth.instance.currentUser;

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
            const SizedBox(height: 25),
            const Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 32,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Profile',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                fontFamily: 'OpenSans',
              ),
            ),
            const SizedBox(height: 15),

            profileUpdateLink(
              route: UpdateUsernamePage.routeName,
              name: "Update Username",
              context: context,
            ),
            const Divider(color: Color(0xFFD6D6D6), thickness: 1),

            profileUpdateLink(
              route: ChangePasswordPage.routeName,
              name: "Change Password",
              context: context,
            ),
            const SizedBox(height: 40),

            // Delete Account
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    () => _confirmDeleteAccount(
                      context,
                      ref,
                      currentUser?.email ?? "",
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
            ),
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
      onTap: () => Navigator.pushNamed(context, route),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
          ),
          const Icon(Icons.arrow_forward_ios_rounded),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteAccount(
    BuildContext context,
    WidgetRef ref,
    String email,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => deleteAccountAlertDialog(ctx),
    );

    if (!context.mounted || shouldDelete != true) return;

    final password = await _showPasswordDialog(context);
    if (password == null || password.isEmpty) return;

    try {
      await ref
          .read(authServiceProvider)
          .deleteAccount(email: email, password: password);

      if (!context.mounted) return;
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting account: $e"),
          backgroundColor: Colors.white,
        ),
      );
    }
  }

  AlertDialog deleteAccountAlertDialog(BuildContext ctx) => AlertDialog(
    backgroundColor: Colors.white,
    title: const Text("Delete Account"),
    content: const Text(
      "Are you sure you want to permanently delete your account? "
      "This action cannot be undone.",
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(ctx).pop(false),
        child: const Text("Cancel", style: TextStyle(color: Colors.black)),
      ),
      ElevatedButton(
        onPressed: () => Navigator.of(ctx).pop(true),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
        child: const Text("Delete", style: TextStyle(color: Colors.white)),
      ),
    ],
  );

  Future<String?> _showPasswordDialog(BuildContext context) async {
    final passwordController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Re-enter Password"),
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
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(passwordController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
