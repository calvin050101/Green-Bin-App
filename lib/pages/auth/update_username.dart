import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/cust_form_field.dart';

class UpdateUsernamePage extends StatefulWidget {
  const UpdateUsernamePage({super.key});

  @override
  State<UpdateUsernamePage> createState() => _UpdateUsernamePageState();
}

class _UpdateUsernamePageState extends State<UpdateUsernamePage> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF00B0FF),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              iconSize: 24.0,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Username',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 32,
                fontFamily: 'Poppins',
              ),
            ),

            SizedBox(height: 40),

            CustFormField(
              controller: _usernameController,
              keyboardType: TextInputType.text,
              hintText: 'New Username',
              isPassword: false,
            ),

            SizedBox(height: 40),

            updateUsernameButton(context),
          ],
        ),
      ),
    );
  }

  void updateUsername() async {
    User? currentUser = authService.value.currentUser;

    if (currentUser == null) return;

    final BuildContext dialogContext = context;
    showDialog(
      context: dialogContext,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final newUsername = _usernameController.text;

    try {
      await authService.value.updateUsername(newUsername);
      await currentUser.reload();
      currentUser = authService.value.currentUser;

      await DatabaseService().updateUsername(newUsername);
      if (dialogContext.mounted) Navigator.pop(dialogContext);
      Navigator.pop(context);
    } on FirebaseAuthException {
      if (dialogContext.mounted) Navigator.pop(dialogContext);
      Navigator.pop(context);
    }
  }

  SizedBox updateUsernameButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: updateUsername,

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00B0FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),

        child: const Text(
          'Update Username',
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
