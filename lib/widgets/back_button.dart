import 'package:flutter/material.dart';

class CustBackButton extends StatelessWidget {
  const CustBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
