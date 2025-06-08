import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/pages/auth/auth.dart';
import 'package:green_bin/pages/auth/change_password.dart';
import 'package:green_bin/pages/auth/update_username.dart';
import 'package:green_bin/pages/profile/recycling_history.dart';
import 'package:green_bin/pages/profile/settings.dart';
import 'package:green_bin/pages/profile/user_levels.dart';
import 'package:green_bin/pages/scan_item/scan_item_main.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const ProviderScope( // Wrap your app with ProviderScope
      child: MyApp(),
    ),
  );
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
      title: 'GreenBin',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => AuthPage(),
        '/scan-item': (context) => ScanItemMainPage(),
        '/user-levels': (context) => UserLevelsPage(),
        '/recycling-history': (context) => RecyclingHistoryPage(),
        '/settings': (context) => SettingsPage(),
        '/update-username': (context) => UpdateUsernamePage(),
        '/change-password': (context) => ChangePasswordPage(),
      },
    );
  }
}
