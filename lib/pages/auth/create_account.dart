import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_bin/services/auth_service.dart';
import 'package:green_bin/services/database_service.dart';

import '../../widgets/cust_form_field.dart';

class CreateAccountPage extends StatefulWidget {
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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

            CustFormField(
              controller: _usernameController,
              keyboardType: TextInputType.name,
              hintText: 'Username',
              isPassword: false,
            ),

            const SizedBox(height: 20.0),

            CustFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: 'Email Address',
              isPassword: false,
            ),

            const SizedBox(height: 20.0),

            CustFormField(
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              hintText: 'Password',
              isPassword: true,
            ),

            const SizedBox(height: 20.0),

            CustFormField(
              controller: _confirmPasswordController,
              keyboardType: TextInputType.visiblePassword,
              hintText: 'Confirm Password',
              isPassword: true,
            ),

            const SizedBox(height: 20.0),

            Text(
              errorMessage,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.0,
                fontFamily: 'Montserrat',
              ),
            ),

            const SizedBox(height: 30.0),

            continueButton(),
          ],
        ),
      ),
    );
  }

  SizedBox continueButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: ElevatedButton(
        onPressed: registerUser,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00B0FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15.0),
        ),
        child: const Text(
          'Continue',
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
