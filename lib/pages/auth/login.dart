import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_bin/pages/auth/create_account.dart';
import 'package:green_bin/services/auth_service.dart';
import 'package:green_bin/widgets/cust_form_field.dart';
import 'package:green_bin/widgets/custom_button.dart';
import 'package:green_bin/widgets/error_message_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';

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

    // try sign in
    try {
      await authService.value.login(
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

            const SizedBox(height: 20.0),

            ErrorMessageText(errorMessage: errorMessage),

            const SizedBox(height: 30.0),

            CustomButton(buttonText: "Continue", onPressed: loginUser),

            const SizedBox(height: 40.0),

            createAccountText(context),
          ],
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
    );
  }

}
