import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),

      body: Column(
        children: [
          Text(
            'Profile',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 32,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
