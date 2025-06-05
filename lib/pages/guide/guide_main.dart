import 'package:flutter/material.dart';

class GuideMainPage extends StatelessWidget {
  const GuideMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),

      body: Column(
        children: [
          Text(
            'Waste Guide',
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
