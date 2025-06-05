import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
                // Navigator.pop(context);
              },
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          Text(
            'Settings',
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
