import 'package:flutter/material.dart';
import 'package:green_bin/models/waste_type_summary.dart';

class WasteTypeSummaryCard extends StatelessWidget {
  final WasteTypeSummary summary;
  const WasteTypeSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: Color(0xFFD6D6D6), width: 2),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(summary.icon, size: 40, color: Theme.of(context).primaryColor),

            const SizedBox(height: 8),

            Text(
              summary.wasteType,
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 4),

            Text(
              summary.count.toString(),
              style: TextStyle(
                fontFamily: 'OpenSans',
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
