import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_bin/pages/auth/create_account.dart';
import 'package:green_bin/widgets/cust_form_field.dart';

import '../../helper/helper_functions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void loginUser() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (context.mounted) Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),

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
              'Login',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 32,
                fontFamily: 'Poppins',
              ),
            ),

            SizedBox(height: 20),

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

            const SizedBox(height: 30.0),

            continueButton(),

            const SizedBox(height: 40.0),

            // "Don't have an Account? Create One" text
            Row(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAccountPage(),
                      ),
                    );
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
            ),
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
        onPressed: loginUser,
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
