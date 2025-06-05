import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

            textFormField(
              _emailController,
              TextInputType.emailAddress,
              'Email Address',
              false,
            ),

            const SizedBox(height: 20.0),

            textFormField(
              _passwordController,
              TextInputType.visiblePassword,
              'Password',
              true,
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
                  onTap: () {},
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
        onPressed: () {},
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

  TextFormField textFormField(
    TextEditingController controller,
    TextInputType keyboardType,
    String hintText,
    bool isPassword,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.brown[400]),
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.green, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.green, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.green, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
      ),
      style: TextStyle(
        color: Colors.brown[700],
        fontFamily: 'Montserrat',
        fontSize: 18,
      ),
    );
  }
}
