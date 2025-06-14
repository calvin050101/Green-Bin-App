import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/recycling_center.dart';

class RecyclingCenterDetailPage extends StatelessWidget {
  final RecyclingCenter center;

  const RecyclingCenterDetailPage({super.key, required this.center});

  Future<void> _launchGoogleMapsDirections(
    double lat,
    double lng,
    String name,
  ) async {
    final Uri url = Uri.parse(
      'google.navigation:q=$lat,$lng&mode=d&q_place_id=${center.id}',
    );
    // Fallback for web or if Google Maps app is not installed
    final Uri webUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&destination_place_id=${center.id}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl);
    } else {
      throw 'Could not launch maps for ${center.name} at ($lat, $lng)';
    }
  }

  Widget _buildDetailRow(
    BuildContext context,
    String title,
    String? value, {
    VoidCallback? onTap,
  }) {
    if (value == null || value.isEmpty || value == 'N/A') {
      return const SizedBox.shrink(); // Don't display if value is null or empty
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: onTap,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: onTap != null ? Colors.blue : Colors.black87,
                decoration:
                    onTap != null
                        ? TextDecoration.underline
                        : TextDecoration.none,
              ),
            ),
          ),
          const Divider(height: 16, thickness: 0.5),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locations Page - Info'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center Image/Photo
            if (center.photoUrl != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(center.photoUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Icon(
                  Icons.recycling,
                  size: 80,
                  color: Colors.grey,
                ),
              ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    center.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(center.distance != null ? (center.distance! / 1000).toStringAsFixed(1) : 'N/A')} km',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),

                  // Google Maps Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _launchGoogleMapsDirections(
                          center.latitude,
                          center.longitude,
                          center.name,
                        );
                      },
                      icon: const Icon(Icons.map, color: Colors.white),
                      label: const Text(
                        'Google Maps',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Google Maps blue
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Details Section
                  _buildDetailRow(context, 'Address', center.address),
                  _buildDetailRow(
                    context,
                    'Operating Hours',
                    center.openingHours.isNotEmpty
                        ? center.openingHours.join(', ')
                        : null,
                  ),
                  _buildDetailRow(
                    context,
                    'Contact No.',
                    center.phoneNumber,
                    onTap: () {},
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
