import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import '../models/recycling_center.dart';
import 'package:latlong2/latlong.dart';
import '../../api_keys.dart';

final googlePlacesProvider = Provider(
  (ref) => GoogleMapsPlaces(apiKey: googlePlacesApiKey),
);

final googlePlacesServiceProvider = Provider(
  (ref) => GooglePlacesService(ref.read(googlePlacesProvider)),
);

class GooglePlacesService {
  final GoogleMapsPlaces _places;

  /// Simple in-memory cache
  final Map<String, List<RecyclingCenter>> _cache = {};

  GooglePlacesService(this._places);

  /// Generate a cache key from location & query
  String _makeCacheKey({
    required double latitude,
    required double longitude,
    required int radius,
    required String query,
  }) => '$latitude|$longitude|$radius|$query';

  /// Search for nearby recycling centers
  Future<List<RecyclingCenter>> searchRecyclingCenters({
    required double latitude,
    required double longitude,
    String query = 'recycling center',
    int radiusMeters = 20000,
  }) async {
    final cacheKey = _makeCacheKey(
      latitude: latitude,
      longitude: longitude,
      radius: radiusMeters,
      query: query,
    );

    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      final response = await _places.searchNearbyWithRadius(
        Location(lat: latitude, lng: longitude),
        radiusMeters,
        keyword: query,
      );

      if (response.status == 'OK') {
        final distanceCalculator = const Distance();
        final currentLatLng = LatLng(latitude, longitude);

        // Map results -> RecyclingCenter + distance
        List<RecyclingCenter> centers =
            response.results.map((result) {
              final center = RecyclingCenter.fromPlaceSearch(result);
              center.distance = distanceCalculator.as(
                LengthUnit.Meter,
                currentLatLng,
                LatLng(center.latitude, center.longitude),
              );
              return center;
            }).toList();

        // Sort nearest first
        centers.sort(
          (a, b) => (a.distance ?? double.infinity).compareTo(
            b.distance ?? double.infinity,
          ),
        );

        _cache[cacheKey] = centers;

        return centers;
      } else if (response.status == 'ZERO_RESULTS') {
        return [];
      } else {
        throw Exception(
          'Failed to load recycling centers from Google Places API: ${response.errorMessage}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get detailed information for a specific place_id
  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    try {
      final response = await _places.getDetailsByPlaceId(placeId);
      if (response.status == 'OK') {
        return response.result;
      } else if (response.status == 'ZERO_RESULTS') {
        return null;
      } else {
        throw Exception(
          'Failed to load place details: ${response.errorMessage}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
