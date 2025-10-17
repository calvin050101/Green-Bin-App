import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants/assets.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;

  @override
  void initState() {
    super.initState();
    checkEmailVerified();
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isEmailVerified =
          FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    });

    if (!isEmailVerified) {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        "Verify Email",
        style: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
      ),
      centerTitle: true,
    ),
    body: Center(
      child:
          isEmailVerified
              ? const Text(
                "Email verified! You can now log in.",
                style: TextStyle(fontFamily: "OpenSans"),
              )
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image(
                      image: AssetImage(AppAssets.recycleBin),
                      width: 200.0,
                      height: 200.0,
                    ),
                  ),
                  SizedBox(height: 40),

                  const Text(
                    "A verification email has been sent.\nPlease check your inbox.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: "OpenSans", fontSize: 18),
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.currentUser?.reload();
                      setState(() {
                        isEmailVerified =
                            FirebaseAuth.instance.currentUser?.emailVerified ??
                            false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text(
                      "I have verified",
                      style: TextStyle(fontFamily: "OpenSans", fontSize: 16),
                    ),
                  ),

                  TextButton(
                    onPressed:
                        canResendEmail
                            ? () async {
                              await FirebaseAuth.instance.currentUser
                                  ?.sendEmailVerification();
                              setState(() => canResendEmail = false);
                              await Future.delayed(const Duration(seconds: 10));
                              setState(() => canResendEmail = true);
                            }
                            : null,
                    child: const Text(
                      "Resend Email",
                      style: TextStyle(fontFamily: "OpenSans", fontSize: 16),
                    ),
                  ),
                ],
              ),
    ),
  );
}
