import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/user_service.dart';
import 'create_account.dart';
import '../../widgets/form/cust_form_field.dart';
import '../../widgets/form/password_form_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/form/error_message_text.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    late BuildContext dialogContext;

    // show loading circle
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        dialogContext = ctx;
        return const Center(child: CircularProgressIndicator());
      },
      barrierDismissible: true,
    );

    try {
      // Call UserService via Riverpod
      final userService = ref.read(userServiceProvider);
      await userService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (dialogContext.mounted) Navigator.pop(dialogContext);
    } on FirebaseAuthException catch (e) {
      if (dialogContext.mounted) Navigator.pop(dialogContext);
      setState(() {
        errorMessage = e.message ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image(
                  image: AssetImage('lib/assets/images/recycle-bin.png'),
                  width: 200.0,
                  height: 200.0,
                ),
              ),
              SizedBox(height: 40),

              Text(
                'Login',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 20),

              // Email Field
              CustFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Email Address',
              ),
              const SizedBox(height: 20.0),

              // Password field
              PasswordFormField(
                controller: _passwordController,
                hintText: 'Password',
              ),
              const SizedBox(height: 20.0),

              if (errorMessage.isNotEmpty)
                ErrorMessageText(errorMessage: errorMessage),
              const SizedBox(height: 5.0),

              // Forgot Password Text
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/forgot-password');
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.brown[700],
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // Continue Button
              CustomButton(buttonText: "Continue", onPressed: loginUser),
              const SizedBox(height: 20.0),

              createAccountText(context),
            ],
          ),
        ),
      ),
    );
  }

  Row createAccountText(BuildContext context) {
    return Row(
      children: [
        Text(
          "Don't have an Account? ",
          style: TextStyle(
            color: Colors.brown[700],
            fontSize: 16.0,
            fontFamily: 'Montserrat',
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, CreateAccountPage.routeName);
          },
          child: Text(
            "Create One",
            style: TextStyle(
              color: Colors.brown[700],
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    );
  }
}
