import 'package:flutter/material.dart';
import 'package:green_bin/pages/scan_item/confirm_waste_type_page.dart';

import '../../widgets/back_button.dart';
import '../../widgets/custom_button.dart';

class ScanItemMainPage extends StatelessWidget {
  static String routeName = "/scan-item";
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scan Item',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 32,
                fontFamily: 'Poppins',
              ),
            ),

            SizedBox(height: 40),

            Center(child: uploadImageContainer(context)),

            const SizedBox(height: 50),

            CustomButton(
              buttonText: "Process Image",
              onPressed: () {
                Navigator.pushNamed(context, ConfirmWasteTypePage.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }

  Container uploadImageContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 80, color: Colors.grey[600]),
          const SizedBox(height: 10),
          Text(
            'Upload Image',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }
}
