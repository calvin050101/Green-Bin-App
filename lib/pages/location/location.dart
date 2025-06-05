import 'package:flutter/material.dart';

class LocationsPage extends StatelessWidget {
  const LocationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),

      body: Column(
        children: [
          Text(
            'Recycling Locations',
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
