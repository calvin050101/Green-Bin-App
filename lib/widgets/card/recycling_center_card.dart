import 'package:flutter/material.dart';
import 'package:green_bin/models/recycling_center.dart';
import 'package:green_bin/pages/location/recycling_center_detail_page.dart';

import '../../helper/location_functions.dart';

class RecyclingCenterCard extends StatelessWidget {
  final RecyclingCenter center;

  const RecyclingCenterCard({super.key, required this.center});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

      child: ListTile(
        leading: const Icon(Icons.recycling, color: Colors.green),
        title: Text(
          center.name,
          style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'OpenSans'),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(center.address, style: TextStyle(fontFamily: 'OpenSans')),
            Text(
              'Distance: ${formatDistance(center.distance)}',
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.blue),
          onPressed: () {
            Navigator.pushNamed(
              context,
              RecyclingCenterDetailPage.routeName,
              arguments: center,
            );
          },
        ),
      ),
    );
  }
}
