import 'package:flutter/material.dart';
import 'package:green_bin/pages/scan_item/complete_scan_page.dart';
import 'package:green_bin/widgets/custom_button.dart';

import '../../widgets/back_button.dart';

class ConfirmWasteTypePage extends StatefulWidget {
  static String routeName = "/confirm-waste-type";

  const ConfirmWasteTypePage({super.key});

  @override
  State<ConfirmWasteTypePage> createState() => _ConfirmWasteTypePageState();
}

class _ConfirmWasteTypePageState extends State<ConfirmWasteTypePage> {
  String _selectedWasteType = "Paper";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: CustBackButton(),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirm Waste Type',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 32,
                fontFamily: 'Poppins',
              ),
            ),

            SizedBox(height: 40),

            Center(child: wasteImageContainer(context)),

            const SizedBox(height: 20),

            predictedWasteTypeContainer(),

            const SizedBox(height: 30),

            const Text(
              'Or select the correct waste type below',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: 'OpenSans',
              ),
            ),

            const SizedBox(height: 15),

            _buildWasteTypeOption(context, Icons.liquor, 'Plastic'),
            _buildWasteTypeOption(context, Icons.description, 'Paper'),
            _buildWasteTypeOption(context, Icons.wine_bar, 'Glass'),
            _buildWasteTypeOption(context, Icons.kitchen, 'Metal'),
            _buildWasteTypeOption(context, Icons.eco, 'Organic'),
            _buildWasteTypeOption(context, Icons.computer, 'E-Waste'),
            _buildWasteTypeOption(context, Icons.checkroom, 'Textiles'),
            _buildWasteTypeOption(
              context,
              Icons.delete_forever,
              'Non-recyclables',
            ),

            const SizedBox(height: 30),

            CustomButton(
              buttonText: "Confirm",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CompleteScanPage(
                          confirmedWasteType: _selectedWasteType,
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Container wasteImageContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!, width: 2),
        image: const DecorationImage(
          image: AssetImage('lib/assets/images/cardboard-box.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildWasteTypeOption(
    BuildContext context,
    IconData icon,
    String value,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color:
          _selectedWasteType == value ? Colors.lightGreen[100] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color:
              _selectedWasteType == value
                  ? Colors.lightGreen
                  : Colors.grey[300]!,
          width: _selectedWasteType == value ? 2.0 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedWasteType = value;
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Row(
            children: [
              Icon(icon, color: Color(0xFF4CAF50), size: 30),
              const SizedBox(width: 20),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                  color: Colors.lightGreen[900],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container predictedWasteTypeContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        children: [
          Text(
            'Predicted Waste Type:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
          SizedBox(width: 10),
          Text(
            'Paper - 90%',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ],
      ),
    );
  }
}
