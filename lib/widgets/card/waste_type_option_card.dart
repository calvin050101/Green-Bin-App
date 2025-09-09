import 'package:flutter/material.dart';
import 'package:green_bin/models/waste_type_model.dart';

class WasteTypeOptionCard extends StatelessWidget {
  final WasteTypeModel wasteType;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const WasteTypeOptionCard({
    super.key,
    required this.wasteType,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: isSelected ? Colors.lightGreen[100] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? Colors.lightGreen : Colors.grey[300]!,
          width: isSelected ? 2.0 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF4CAF50), size: 30),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  "${wasteType.label} "
                  "(${wasteType.points} pts, ${wasteType.carbonFootprint.toStringAsFixed(2)} kg CO₂)",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500,
                    color: Colors.lightGreen[900],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
