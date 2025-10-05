import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailSent = false;

  @override
  void initState() {
    super.initState();
    _sendVerificationEmail();
  }

  Future<void> _sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      setState(() => isEmailSent = true);
    }
  }

  Future<void> _checkVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    if (user != null && user.emailVerified) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Verify Your Email"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "We've sent a verification email. Please check your inbox.",
              style: TextStyle(fontSize: 18, fontFamily: "Poppins"),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            if (isEmailSent)
              const Text(
                "Verification email sent again.",
                style: TextStyle(fontSize: 18, fontFamily: "Poppins"),
              ),
            const SizedBox(height: 20),

            CustomButton(
              onPressed: _sendVerificationEmail,
              buttonText: 'Resend Email',
            ),
            const SizedBox(height: 20),

            CustomButton(
              onPressed: _checkVerification,
              buttonText: 'I have verified',
            ),
          ],
        ),
      ),
    );
  }
}
