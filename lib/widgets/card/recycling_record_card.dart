import 'package:flutter/material.dart';
import 'package:green_bin/models/record_model.dart';
import 'package:intl/intl.dart';

import '../../helper/waste_type_functions.dart';

class RecyclingRecordCard extends StatelessWidget {
  final RecordModel record;

  const RecyclingRecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.white,
      borderOnForeground: true,
      child: ListTile(
        leading: Icon(
          getWasteTypeIcon(record.wasteType),
          color: Colors.green,
          size: 30,
        ),
        title: Text(
          record.wasteType,
          style: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          DateFormat('yyyy-MM-dd hh:mm a').format(record.timestamp.toLocal()),
          style: const TextStyle(fontFamily: 'OpenSans', fontSize: 12),
        ),
        trailing: Text(
          "${record.weight.toStringAsFixed(2)} kg",
          style: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}