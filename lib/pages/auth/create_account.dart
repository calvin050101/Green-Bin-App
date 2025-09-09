import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_bin/services/auth_service.dart';
import 'package:green_bin/services/database_service.dart';
import 'package:green_bin/widgets/custom_button.dart';

import '../../widgets/back_button.dart';
import '../../widgets/form/cust_form_field.dart';
import '../../widgets/form/error_message_text.dart';
import '../../widgets/form/password_form_field.dart';

class CreateAccountPage extends StatefulWidget {
  static String routeName = "/create-account";
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void registerUser() async {
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

    // make sure passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      if (dialogContext.mounted) {
        Navigator.pop(dialogContext);
      }
      setState(() {
        errorMessage = "Passwords don't match";
      });
      return;
    }

    // try creating the user
    try {
      // create user
      UserCredential? userCredential = await authService.value.createAccount(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await DatabaseService().createUser(
        userCredential: userCredential,
        username: _usernameController.text,
        email: _emailController.text,
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
              Center(
                child: Image(
                  image: AssetImage('lib/assets/images/recycle-bin.png'),
                  width: 200.0,
                  height: 200.0,
                ),
              ),

              SizedBox(height: 40),

              Text(
                'Create Account',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  fontFamily: 'Poppins',
                ),
              ),

              SizedBox(height: 20),

              // Username Field
              CustFormField(
                controller: _usernameController,
                keyboardType: TextInputType.name,
                hintText: 'Username',
              ),

              const SizedBox(height: 20.0),

              // Email Field
              CustFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Email Address',
              ),

              const SizedBox(height: 20.0),

              // Password Field
              PasswordFormField(
                controller: _passwordController,
                hintText: 'Password',
              ),

              const SizedBox(height: 20.0),

              // Confirm password field
              PasswordFormField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
              ),

              const SizedBox(height: 20.0),

              if (errorMessage != "")
                ErrorMessageText(errorMessage: errorMessage),
              const SizedBox(height: 30.0),

              // Continue Button
              CustomButton(buttonText: "Continue", onPressed: registerUser),
            ],
          ),
        ),
      ),
    );
  }
}
