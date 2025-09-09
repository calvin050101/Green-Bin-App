import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/back_button.dart';
import '../../widgets/form/cust_form_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/form/error_message_text.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const routeName = '/forgot-password';

  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  late String _errorMessage = "";

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? '';
      });
    }
  }

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
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              Text(
                'Forgot Password',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 20),

              Text(
                'Enter your email and we will send you a link to reset your password.',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  fontFamily: 'OpenSans',
                ),
              ),
              SizedBox(height: 40),

              // Email Field
              CustFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Email Address',
              ),
              const SizedBox(height: 20.0),

              if (_errorMessage != "")
                ErrorMessageText(errorMessage: _errorMessage),
              const SizedBox(height: 0.0),

              // Continue Button
              CustomButton(
                buttonText: "Reset Password",
                onPressed: () => passwordReset(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
