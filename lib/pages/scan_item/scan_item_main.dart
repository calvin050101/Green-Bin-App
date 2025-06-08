import 'package:flutter/material.dart';

import '../../widgets/back_button.dart';

class ScanItemMainPage extends StatelessWidget {
  const ScanItemMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: CustBackButton(),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text(
              'Scan Item',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 32,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),

    );
  }
}
