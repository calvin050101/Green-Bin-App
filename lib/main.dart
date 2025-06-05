import 'package:flutter/material.dart';
import 'package:green_bin/pages/auth/login.dart';
// import 'package:green_bin/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Color(0xFF4CAF50),
          secondary: Color(0xFF03A9F4),
          surface: Color(0xFF333333),
        ),
        scaffoldBackgroundColor: Color(0xFFF9FBE7),
      ),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
