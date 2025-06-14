import 'package:flutter_google_maps_webservices/places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../models/recycling_center.dart';

const String googlePlacesApiKey = 'AIzaSyAoGQ_zpJHqQIYPhgLdgGjTC0IOXlb7c2w';

// Provider for the Google Places API client
final googlePlacesProvider = Provider(
      (ref) => GoogleMapsPlaces(apiKey: googlePlacesApiKey),
);

final recyclingCentersProvider = FutureProvider.autoDispose<List<RecyclingCenter>>((ref) async {
  final places = ref.watch(googlePlacesProvider);

  try {
    // 1. Get current location
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are denied. Cannot find recycling centers.");
      }
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10), // Add a timeout
    );

    // 2. Search for recycling centers near the current location
    final PlacesSearchResponse response = await places.searchNearbyWithRadius(
      Location(lat: position.latitude, lng: position.longitude),
      50000, // Search within 50 km radius (adjust as needed)
      keyword: 'recycling center', // Text search query
      type: 'point_of_interest', // Broader type that often includes recycling centers
    );

    if (response.status == 'OK') {
      List<RecyclingCenter> centers = response.results
          .map((result) => RecyclingCenter.fromPlaceSearch(result))
          .toList();

      // Manually calculate distance and sort
      final currentLatLng = LatLng(position.latitude, position.longitude);
      for (var center in centers) {
        center.distance = const Distance().as(
          LengthUnit.Meter,
          currentLatLng,
          LatLng(center.latitude, center.longitude),
        );
      }

      // Sort by distance (closest first)
      centers.sort((a, b) => (a.distance ?? double.infinity).compareTo(b.distance ?? double.infinity));

      return centers;
    } else if (response.status == 'ZERO_RESULTS') {
      return []; // No results found
    } else {
      throw Exception('Places API error: ${response.errorMessage}');
    }
  } catch (e) {
    // Handle location or API errors
    print('Error fetching recycling centers: $e');
    rethrow; // Re-throw to be caught by the FutureProvider's error state
  }
});