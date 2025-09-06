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

  GooglePlacesService(this._places);

  // ... (Your existing searchRecyclingCenters method) ...
  Future<List<RecyclingCenter>> searchRecyclingCenters({
    required double latitude,
    required double longitude,
    String query = 'recycling center',
    int radiusMeters = 32000,
  }) async {
    try {
      final PlacesSearchResponse response = await _places.searchByText(
        query,
        location: Location(lat: latitude, lng: longitude),
        radius: radiusMeters,
      );

      if (response.status == 'OK') {
        List<RecyclingCenter> centers =
            response.results
                .map((result) => RecyclingCenter.fromPlaceSearch(result))
                .toList();

        final currentLatLng = LatLng(latitude, longitude);
        for (var center in centers) {
          center.distance = const Distance().as(
            LengthUnit.Meter,
            currentLatLng,
            LatLng(center.latitude, center.longitude),
          );
        }

        centers.sort(
          (a, b) => (a.distance ?? double.infinity).compareTo(
            b.distance ?? double.infinity,
          ),
        );

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

  // NEW METHOD: Get detailed information for a specific place_id
  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    try {
      // Specify the fields you want to retrieve to optimize costs and data usage.
      // Basic fields for contact info, website, opening hours.
      final PlacesDetailsResponse response = await _places.getDetailsByPlaceId(
        placeId,
      );

      if (response.status == 'OK') {
        return response.result;
      } else if (response.status == 'ZERO_RESULTS') {
        return null; // No details found for this ID
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
