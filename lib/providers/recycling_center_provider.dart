import 'package:flutter_google_maps_webservices/places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../api_keys.dart';
import '../models/recycling_center.dart';
import '../services/google_places_service.dart';

// Provider for the Google Places API client
final googlePlacesProvider = Provider(
  (ref) => GoogleMapsPlaces(apiKey: googlePlacesApiKey),
);

final recyclingCentersProvider =
    FutureProvider.autoDispose<List<RecyclingCenter>>((ref) async {
      final places = ref.watch(googlePlacesProvider);

      try {
        // 1. Get current location
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied ||
              permission == LocationPermission.deniedForever) {
            throw Exception(
              "Location permissions are denied. Cannot find recycling centers.",
            );
          }
        }
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );

        // 2. Search for recycling centers near the current location
        final googlePlacesService = GooglePlacesService(places);
        final centers = await googlePlacesService.searchRecyclingCenters(
          latitude: position.latitude,
          longitude: position.longitude,
        );

        return centers;
      } catch (e) {
        // Handle location or API errors
        print('Error fetching recycling centers: $e');
        rethrow; // Re-throw to be caught by the FutureProvider's error state
      }
    });

// New provider to fetch detailed information for a single recycling center
final recyclingCenterDetailsProvider = FutureProvider.family
    .autoDispose<PlaceDetails?, String>((ref, placeId) async {
      final googlePlacesService = ref.watch(googlePlacesServiceProvider);
      return googlePlacesService.getPlaceDetails(placeId);
    });
