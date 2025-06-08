import 'package:flutter/material.dart';

import '../../widgets/back_button.dart';

class RecyclingHistoryPage extends StatelessWidget {
  const RecyclingHistoryPage({super.key});

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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Text(
              'Recycling History',
              style: TextStyle(
                fontWeight: FontWeight.w700,
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
