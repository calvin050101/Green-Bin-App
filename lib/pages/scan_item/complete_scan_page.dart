import 'package:flutter/material.dart';
import 'package:green_bin/widgets/custom_button.dart';

class CompleteScanPage extends StatelessWidget {
  const CompleteScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _wasteImageContainer(context),

              const SizedBox(height: 30),

              Text(
                'Thank you for recycling!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreen[900],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              _buildInfoRow('Waste Type:', 'Cardboard'),
              _buildInfoRow('Points:', '7'),
              _buildInfoRow('Carbon Footprint Saved:', '0.2 kg CO₂'),

              const SizedBox(height: 40),

              CustomButton(
                buttonText: 'OK',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _wasteImageContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[400]!),
        image: const DecorationImage(
          image: AssetImage('lib/assets/images/cardboard-box.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'OpenSans',
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'OpenSans',
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
