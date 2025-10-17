import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/pages/auth/login.dart';
import 'package:green_bin/pages/auth/verify_email.dart';
import '../main_wrapper_screen.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;

          if (user == null) {
            return const LoginPage();
          }

          if (!user.emailVerified) {
            return const VerifyEmailPage();
          }

          return const MainWrapperScreen();
        },
      ),
    );
  }
}

