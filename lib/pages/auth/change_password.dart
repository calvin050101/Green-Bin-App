import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';
import '../../services/auth_service.dart';
import '../../widgets/back_button.dart';

import '../../widgets/form/error_message_text.dart';
import '../../widgets/form/password_form_field.dart';

class ChangePasswordPage extends StatefulWidget {
  static String routeName = "/change-password";
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  String errorMessage = '';

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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change Password',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 32,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 40),

            PasswordFormField(
              controller: _oldPasswordController,
              hintText: 'Old Password',
            ),
            SizedBox(height: 20),

            PasswordFormField(
              controller: _newPasswordController,
              hintText: 'New Password',
            ),
            SizedBox(height: 20),

            PasswordFormField(
              controller: _confirmNewPasswordController,
              hintText: 'Confirm New Password',
            ),
            SizedBox(height: 10),

            ErrorMessageText(errorMessage: errorMessage),
            SizedBox(height: 40),

            CustomButton(
              buttonText: "Change Password",
              onPressed: changePassword,
            ),
          ],
        ),
      ),
    );
  }

  void changePassword() async {
    // show loading circle
    late BuildContext dialogContext;

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        dialogContext = ctx;
        return const Center(child: CircularProgressIndicator());
      },
    );

    if (_newPasswordController.text != _confirmNewPasswordController.text) {
      if (dialogContext.mounted) {
        Navigator.pop(dialogContext);
      }
      setState(() {
        errorMessage = "Passwords don't match";
      });
      return;
    }

    try {
      User? currentUser = authService.value.currentUser;

      await authService.value.resetPassword(
        email: currentUser!.email!,
        currentPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (dialogContext.mounted) Navigator.pop(dialogContext);
    } on FirebaseAuthException catch (e) {
      if (dialogContext.mounted) Navigator.pop(dialogContext);
      setState(() {
        errorMessage = e.message ?? '';
      });
    }
  }
}
