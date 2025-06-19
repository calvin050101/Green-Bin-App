import 'package:url_launcher/url_launcher.dart';

import '../models/recycling_center.dart';

Future<void> launchGoogleMapsDirections(
    RecyclingCenter center,
    String name,
    ) async {
  final lat = center.latitude;
  final lng = center.longitude;

  final Uri url = Uri.parse(
    'google.navigation:q=$lat,$lng&mode=d&q_place_id=${center.id}',
  );

  // Fallback for web or if Google Maps app is not installed
  final Uri webUrl = Uri(
    scheme: 'https',
    host: 'www.google.com',
    path: '/maps/dir/',
    queryParameters: {
      'api': '1',
      'destination': '$lat,$lng',
      'destination_place_id': center.id,
    },
  );

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else if (await canLaunchUrl(webUrl)) {
    await launchUrl(webUrl);
  } else {
    throw 'Could not launch maps for ${center.name} at ($lat, $lng)';
  }
}

String formatDistance(double? meters) {
  if (meters == null) return 'N/A';
  if (meters < 1000) {
    return '${meters.toStringAsFixed(0)} m';
  } else {
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
}